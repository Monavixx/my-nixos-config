pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.core

// Polls only while `active` is true (the control center sets it when open).
Singleton {
    id: root

    property bool active: false

    property real cpu: 0          // 0..1
    property real memUsed: 0      // GiB
    property real memTotal: 1     // GiB
    property real temp: -1        // °C, -1 = unavailable
    property real diskUsed: 0     // GiB
    property real diskTotal: 1    // GiB

    property real prevTotal: 0
    property real prevIdle: 0

    onActiveChanged: if (!active) prevTotal = 0

    function update() {
        statFile.reload()
        memFile.reload()
        tempFile.reload()
        if (!diskProc.running) diskProc.running = true
    }

    Timer {
        running: root.active
        interval: 2000
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }

    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: {
            const f = text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number)
            const idle = f[3] + (f[4] || 0)
            const total = f.slice(0, 8).reduce((a, b) => a + b, 0)
            const dt = total - root.prevTotal
            const di = idle - root.prevIdle
            if (root.prevTotal > 0 && dt > 0) root.cpu = Math.max(0, Math.min(1, 1 - di / dt))
            root.prevTotal = total
            root.prevIdle = idle
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const t = text()
            const get = k => {
                const m = t.match(new RegExp(k + ":\\s+(\\d+)"))
                return m ? Number(m[1]) : 0
            }
            root.memTotal = get("MemTotal") / 1048576
            root.memUsed = root.memTotal - get("MemAvailable") / 1048576
        }
    }

    FileView {
        id: tempFile
        path: Config.cpuTempPath
        onLoaded: {
            const v = Number(text())
            root.temp = isNaN(v) ? -1 : v / 1000
        }
    }

    Process {
        id: diskProc
        command: ["df", "-B1", "--output=used,size", Config.diskPath]
        stdout: StdioCollector {
            onStreamFinished: {
                const l = text.trim().split("\n")[1]
                if (!l) return
                const p = l.trim().split(/\s+/).map(Number)
                root.diskUsed = p[0] / 1073741824
                root.diskTotal = p[1] / 1073741824
            }
        }
    }
}
