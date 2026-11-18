pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.core

// Taskwarrior backend. Everything goes through the `task` CLI (by uuid, since ids shift).
Singleton {
    id: root

    property var tasks: []
    property bool loading: false
    property var queue: []

    readonly property int count: tasks.length
    readonly property int overdue: tasks.filter(t => dueInfo(t.due).level === 2).length

    // Emitted right before `tasks` is replaced, so the UI can remember its scroll position
    signal tasksAboutToChange()

    function setTasks(arr) {
        tasksAboutToChange()
        tasks = arr
    }

    function refresh() {
        if (exportProc.running) return
        loading = true
        exportProc.running = true
    }

    // Mutations run one at a time, then we re-export
    function run(args) {
        queue.push(args)
        next()
    }
    function next() {
        if (runner.running || queue.length === 0) return
        runner.command = ["task", "rc.confirmation=off", "rc.verbose=nothing"].concat(queue.shift())
        runner.running = true
    }

    // Plain Taskwarrior syntax works: "buy milk project:home +shopping due:friday"
    function add(text) {
        const parts = text.trim().split(/\s+/)
        if (!parts[0]) return
        run(["add"].concat(parts))
    }
    function done(uuid) {
        setTasks(tasks.filter(t => t.uuid !== uuid))
        run([uuid, "done"])
    }
    function remove(uuid) {
        setTasks(tasks.filter(t => t.uuid !== uuid))
        run([uuid, "delete"])
    }
    function toggleStart(t) {
        run([t.uuid, t.start !== undefined ? "stop" : "start"])
    }

    // ── helpers for the UI ──
    // Taskwarrior dates look like 20261113T120000Z (UTC)
    function parseDate(s) {
        const m = /^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})Z$/.exec(s || "")
        return m ? new Date(Date.UTC(+m[1], +m[2] - 1, +m[3], +m[4], +m[5], +m[6])) : null
    }

    // level: 0 = normal, 1 = due today, 2 = overdue
    function dueInfo(s) {
        const d = parseDate(s)
        if (!d) return { text: "", level: 0 }
        const now = new Date()
        const startToday = new Date(now.getFullYear(), now.getMonth(), now.getDate())
        const dayDiff = Math.round((new Date(d.getFullYear(), d.getMonth(), d.getDate()) - startToday) / 86400000)
        const hasTime = d.getHours() !== 0 || d.getMinutes() !== 0
        const time = Qt.formatDateTime(d, "HH:mm")

        // A date without a time is only overdue once that day is over
        const late = hasTime ? d < now : dayDiff < 0
        if (late) {
            return { level: 2, text: dayDiff === 0 ? "overdue (" + time + ")" : "overdue " + (-dayDiff) + "d" }
        }
        if (dayDiff === 0) return { level: 1, text: hasTime ? "today " + time : "today" }
        if (dayDiff === 1) return { level: 0, text: hasTime ? "tomorrow " + time : "tomorrow" }
        if (dayDiff < 7) return { level: 0, text: Qt.locale().dayName(d.getDay(), Locale.ShortFormat) }
        return { level: 0, text: Qt.formatDate(d, "d MMM") }
    }

    function meta(t) {
        const parts = []
        if (t.project) parts.push(t.project)
        if (t.tags && t.tags.length > 0) parts.push(t.tags.map(x => "+" + x).join(" "))
        return parts.join("  ·  ")
    }

    function priorityColor(p) {
        return p === "H" ? Theme.red : p === "M" ? Theme.yellow : p === "L" ? Theme.blue : Theme.fgMuted
    }

    Process {
        id: exportProc
        command: ["task", "rc.verbose=nothing", "rc.json.array=on"].concat(Config.taskFilter).concat(["export"])
        stdout: StdioCollector {
            onStreamFinished: {
                root.loading = false
                if (text.trim() === "") { root.setTasks([]); return }
                try {
                    const arr = JSON.parse(text)
                    arr.sort((a, b) => (b.urgency || 0) - (a.urgency || 0))
                    root.setTasks(arr)
                } catch (e) {
                    console.warn("Tasks: could not parse `task export` output:", e)
                }
            }
        }
    }

    Process {
        id: runner
        onRunningChanged: {
            if (running) return
            if (root.queue.length > 0) root.next()
            else root.refresh()
        }
    }

    // Keeps the overdue badge honest while the popup is closed
    Timer {
        running: true
        interval: 300000
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
