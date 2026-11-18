import QtQuick
import Quickshell
import Quickshell.Io
import qs.core
import qs.components

BarButton {
    id: root

    property string kind: "none"   // wifi | ethernet | none
    property string name: ""

    function refresh() {
        if (!query.running) query.running = true
    }

    Process {
        id: query
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]
        stdout: StdioCollector {
            onStreamFinished: {
                let k = "none", n = ""
                for (const line of text.split("\n")) {
                    const p = line.split(":")
                    if (!p[1] || !p[1].startsWith("connected")) continue
                    if (p[0] === "ethernet") { k = "ethernet"; n = p[2]; break }
                    if (p[0] === "wifi" && k === "none") { k = "wifi"; n = p[2] }
                }
                root.kind = k
                root.name = n
            }
        }
    }

    // Re-query whenever NetworkManager reports a change
    Process {
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser { onRead: debounce.restart() }
    }
    Timer { id: debounce; interval: 400; onTriggered: root.refresh() }
    Component.onCompleted: refresh()

    BarIcon {
        text: root.kind === "ethernet" ? "\uf0e8" : "\uf1eb"
        color: root.kind === "none" ? Theme.peach : Theme.fg
    }

    onClicked: Quickshell.execDetached(Config.terminal.concat(Config.networkTui))
}
