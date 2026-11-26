#!/usr/bin/env python3
import argparse
from contextlib import contextmanager
import json
import logging
import math
import os
from pathlib import Path
import sqlite3
import subprocess
import sys
import time
import uuid


LOG = logging.getLogger("quickshell-timers")


def database_path():
    configured = os.environ.get("QS_TIMERS_DB")
    if configured:
        return Path(configured)
    state_home = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    return state_home / "quickshell-timers.sqlite3"


@contextmanager
def connect():
    path = database_path()
    path.parent.mkdir(parents=True, exist_ok=True)
    db = sqlite3.connect(path, timeout=5)
    db.row_factory = sqlite3.Row
    db.execute(
        """
        CREATE TABLE IF NOT EXISTS schedules (
            id TEXT PRIMARY KEY,
            kind TEXT NOT NULL CHECK (kind IN ('timer', 'alarm')),
            label TEXT NOT NULL,
            status TEXT NOT NULL CHECK (status IN ('running', 'paused')),
            deadline REAL,
            remaining REAL,
            created_at REAL NOT NULL
        )
        """
    )
    try:
        yield db
        db.commit()
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()


def valid_label(label, default):
    cleaned = label.strip()
    if not cleaned:
        return default
    if len(cleaned) > 120:
        raise ValueError("Labels must be 120 characters or fewer")
    return cleaned


def add_timer(seconds, label):
    if not math.isfinite(seconds) or seconds <= 0:
        raise ValueError("Timer duration must be greater than zero")
    now = time.time()
    item_id = str(uuid.uuid4())
    with connect() as db:
        db.execute(
            "INSERT INTO schedules VALUES (?, 'timer', ?, 'running', ?, NULL, ?)",
            (item_id, valid_label(label, "Timer"), now + seconds, now),
        )
    return item_id


def add_alarm(deadline, label):
    if not math.isfinite(deadline) or deadline <= time.time():
        raise ValueError("Alarm time must be in the future")
    item_id = str(uuid.uuid4())
    with connect() as db:
        db.execute(
            "INSERT INTO schedules VALUES (?, 'alarm', ?, 'running', ?, NULL, ?)",
            (item_id, valid_label(label, "Alarm"), deadline, time.time()),
        )
    return item_id


def list_schedules(now=None):
    now = time.time() if now is None else now
    with connect() as db:
        rows = db.execute(
            "SELECT id, kind, label, status, deadline, remaining "
            "FROM schedules ORDER BY deadline, created_at"
        ).fetchall()
    items = []
    for row in rows:
        item = dict(row)
        item["remaining"] = (
            max(0, item["remaining"])
            if item["status"] == "paused"
            else max(0, item["deadline"] - now)
        )
        items.append(item)
    return items


def pause_timer(item_id, now=None):
    now = time.time() if now is None else now
    with connect() as db:
        result = db.execute(
            "UPDATE schedules SET status = 'paused', remaining = MAX(0, deadline - ?), "
            "deadline = NULL WHERE id = ? AND kind = 'timer' AND status = 'running'",
            (now, item_id),
        )
    if result.rowcount == 0:
        raise ValueError("Running timer not found")


def resume_timer(item_id, now=None):
    now = time.time() if now is None else now
    with connect() as db:
        result = db.execute(
            "UPDATE schedules SET status = 'running', deadline = ? + remaining, "
            "remaining = NULL WHERE id = ? AND kind = 'timer' AND status = 'paused'",
            (now, item_id),
        )
    if result.rowcount == 0:
        raise ValueError("Paused timer not found")


def remove_schedule(item_id):
    with connect() as db:
        result = db.execute("DELETE FROM schedules WHERE id = ?", (item_id,))
    if result.rowcount == 0:
        raise ValueError("Timer or alarm not found")


def discard_missed(now=None):
    now = time.time() if now is None else now
    with connect() as db:
        db.execute("BEGIN IMMEDIATE")
        rows = db.execute(
            "SELECT id FROM schedules WHERE status = 'running' AND deadline <= ?",
            (now,),
        ).fetchall()
        if rows:
            db.executemany("DELETE FROM schedules WHERE id = ?", [(row["id"],) for row in rows])
    return len(rows)


def take_due(now=None):
    now = time.time() if now is None else now
    with connect() as db:
        db.execute("BEGIN IMMEDIATE")
        rows = db.execute(
            "SELECT id, kind, label FROM schedules "
            "WHERE status = 'running' AND deadline <= ?",
            (now,),
        ).fetchall()
        if rows:
            db.executemany("DELETE FROM schedules WHERE id = ?", [(row["id"],) for row in rows])
    return [dict(row) for row in rows]


def notify(item):
    title = "Timer finished" if item["kind"] == "timer" else "Alarm"
    try:
        subprocess.run(
            ["notify-send", "--urgency=critical", "--app-name=Timers", title, item["label"]],
            check=True,
            timeout=10,
        )
    except (OSError, subprocess.SubprocessError) as error:
        LOG.error("Could not send completion notification for %s: %s", item["id"], error)
    try:
        sound_path = os.environ.get("QS_TIMER_SOUND")
        if not sound_path:
            raise RuntimeError("QS_TIMER_SOUND is not configured")
        subprocess.run(["pw-play", sound_path], check=True, timeout=20)
    except (OSError, RuntimeError, subprocess.SubprocessError) as error:
        LOG.error("Could not play completion sound for %s: %s", item["id"], error)


def run_daemon():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    missed = discard_missed()
    if missed:
        LOG.info("Skipped %d schedule(s) that expired while the scheduler was unavailable", missed)
    while True:
        for item in take_due():
            notify(item)
        time.sleep(1)


def respond(result):
    print(json.dumps({"ok": True, **result}))


def parse_args():
    parser = argparse.ArgumentParser(prog="quickshell-timers")
    commands = parser.add_subparsers(dest="action", required=True)
    commands.add_parser("daemon")
    commands.add_parser("list")
    timer = commands.add_parser("add-timer")
    timer.add_argument("seconds", type=float)
    timer.add_argument("label")
    alarm = commands.add_parser("add-alarm")
    alarm.add_argument("deadline", type=float, help="Unix timestamp in seconds")
    alarm.add_argument("label")
    for name in ("pause", "resume", "remove"):
        command = commands.add_parser(name)
        command.add_argument("id")
    return parser.parse_args()


def main():
    args = parse_args()
    if args.action == "daemon":
        run_daemon()
        return 0
    try:
        if args.action == "list":
            respond({"items": list_schedules()})
        elif args.action == "add-timer":
            respond({"id": add_timer(args.seconds, args.label)})
        elif args.action == "add-alarm":
            respond({"id": add_alarm(args.deadline, args.label)})
        elif args.action == "pause":
            pause_timer(args.id)
            respond({})
        elif args.action == "resume":
            resume_timer(args.id)
            respond({})
        elif args.action == "remove":
            remove_schedule(args.id)
            respond({})
    except (OSError, sqlite3.Error, ValueError) as error:
        print(json.dumps({"ok": False, "error": str(error)}))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
