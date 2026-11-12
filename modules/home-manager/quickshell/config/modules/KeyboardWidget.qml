import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.core
import qs.components

BarButton {
    id: root

    property string layoutName: ""
    property string mainKeyboard: ""

    readonly property var shortNames: ({
        "English": "EN", "Russian": "RU", "German": "DE", "French": "FR",
        "Spanish": "ES", "Ukrainian": "UA", "Polish": "PL", "Italian": "IT",
        "Portuguese": "PT", "Japanese": "JP", "Chinese": "ZH", "Korean": "KR"
    })
    readonly property string code: {
        if (!layoutName) return "--"
        const first = layoutName.split(" ")[0]
        return shortNames[first] || first.slice(0, 2).toUpperCase()
    }

    // Initial layout
    Process {
        running: true
        command: ["hyprctl", "devices", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const kbs = JSON.parse(text).keyboards
                    const main = kbs.find(k => k.main) || kbs[0]
                    if (main) {
                        root.mainKeyboard = main.name
                        root.layoutName = main.active_keymap
                    }
                } catch (e) {}
            }
        }
    }

    // Live updates. Event data format: "<keyboard-name>,<layout name>"
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name !== "activelayout") return
            const i = event.data.indexOf(",")
            const kb = event.data.slice(0, i)
            const lay = event.data.slice(i + 1)
            if (root.mainKeyboard === "" || kb === root.mainKeyboard) root.layoutName = lay
        }
    }

    BarIcon { text: "\uf11c"; color: Theme.fgDim }
    BarText { text: root.code; font.bold: true }

    onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
}
