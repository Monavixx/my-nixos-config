pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.core

Singleton {
    id: root

    property var files: []
    property string current: ""
    property bool timerActive: false
    property bool scanning: false

    function toUrl(path) {
        return "file://" + path.split("/").map(encodeURIComponent).join("/")
    }

    function scan() {
        if (scanProc.running) return
        scanning = true
        scanProc.running = true
    }

    function refreshState() {
        if (!queryProc.running) queryProc.running = true
        if (!timerQuery.running) timerQuery.running = true
    }

    function set(path) {
        current = path
        Quickshell.execDetached(["awww", "img", path].concat(Config.awwwArgs))
    }

    function random() {
        Quickshell.execDetached(Config.randomCommand)
        queryDelay.restart()
    }

    function toggleTimer() {
        timerSet.command = ["systemctl", "--user", timerActive ? "stop" : "start", Config.wallpaperTimer]
        timerSet.running = true
    }

    Timer { id: queryDelay; interval: 1500; onTriggered: root.refreshState() }

    Process {
        id: scanProc
        command: ["find", "-L", Config.wallpaperDir, "-type", "f", "(",
                  "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg",
                  "-o", "-iname", "*.webp", "-o", "-iname", "*.gif", "-o", "-iname", "*.bmp", ")"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.files = text.split("\n").filter(l => l.length > 0).sort((a, b) => a.localeCompare(b))
                root.scanning = false
            }
        }
    }

    // `awww query` prints e.g. "...: currently displaying: image: /path/to/file.png"
    Process {
        id: queryProc
        command: ["awww", "query"]
        stdout: StdioCollector {
            onStreamFinished: {
                const m = text.match(/image: (.+)$/m)
                if (m) root.current = m[1].trim()
            }
        }
    }

    Process {
        id: timerQuery
        command: ["systemctl", "--user", "is-active", Config.wallpaperTimer]
        stdout: StdioCollector { onStreamFinished: root.timerActive = text.trim() === "active" }
    }

    Process {
        id: timerSet
        onRunningChanged: if (!running) root.refreshState()
    }
}
