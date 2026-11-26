pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool active: false
    property bool loading: false
    property bool loaded: false
    property string errorMessage: ""
    property var schedules: []
    property var commandQueue: []

    readonly property var timers: schedules.filter(item => item.kind === "timer")
    readonly property var alarms: schedules.filter(item => item.kind === "alarm")
    readonly property int count: schedules.length

    function refresh() {
        if (listProcess.running)
            return;
        loading = true;
        listProcess.running = true;
    }

    function addTimer(seconds, label) {
        enqueue(["add-timer", String(seconds), label || "Timer"]);
    }

    function addAlarm(deadline, label) {
        enqueue(["add-alarm", String(deadline), label || "Alarm"]);
    }

    function pause(id) {
        enqueue(["pause", id]);
    }

    function resume(id) {
        enqueue(["resume", id]);
    }

    function remove(id) {
        enqueue(["remove", id]);
    }

    function enqueue(args) {
        commandQueue = commandQueue.concat([args]);
        runNext();
    }

    function runNext() {
        if (commandProcess.running || commandQueue.length === 0)
            return;
        const args = commandQueue[0];
        commandQueue = commandQueue.slice(1);
        commandProcess.command = ["quickshell-timers"].concat(args);
        commandProcess.running = true;
    }

    function handleList(text) {
        loading = false;
        try {
            const result = JSON.parse(text);
            if (!result.ok)
                throw new Error(result.error || "Scheduler failed to list schedules");
            schedules = result.items;
            loaded = true;
            errorMessage = "";
        } catch (error) {
            errorMessage = "Could not load timers and alarms: " + error;
            console.warn("Timers:", errorMessage);
        }
    }

    function handleCommand(text) {
        try {
            const result = JSON.parse(text);
            if (!result.ok)
                throw new Error(result.error || "Scheduler command failed");
            errorMessage = "";
            refresh();
        } catch (error) {
            errorMessage = "Could not update timer or alarm: " + error;
            console.warn("Timers:", errorMessage);
        }
        Qt.callLater(runNext);
    }

    onActiveChanged: if (active)
        refresh()

    Component.onCompleted: refresh()

    Timer {
        running: root.active
        interval: 1000
        repeat: true
        onTriggered: root.refresh()
    }

    Process {
        id: listProcess
        command: ["quickshell-timers", "list"]
        stdout: StdioCollector {
            onStreamFinished: root.handleList(text)
        }
        stderr: StdioCollector {
            onStreamFinished: if (text.trim().length > 0) {
                root.errorMessage = text.trim();
                console.warn("Timers:", text.trim());
            }
        }
    }

    Process {
        id: commandProcess
        onRunningChanged: if (!running)
            Qt.callLater(root.runNext)
        stdout: StdioCollector {
            onStreamFinished: root.handleCommand(text)
        }
        stderr: StdioCollector {
            onStreamFinished: if (text.trim().length > 0) {
                root.errorMessage = text.trim();
                console.warn("Timers:", text.trim());
            }
        }
    }
}
