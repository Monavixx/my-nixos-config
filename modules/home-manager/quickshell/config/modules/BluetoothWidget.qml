import QtQuick
import Quickshell.Bluetooth
import qs.core
import qs.components

BarButton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool powered: adapter ? adapter.enabled : false
    readonly property int connectedCount: Bluetooth.devices.values.filter(d => d.connected).length

    BarIcon {
        text: "\uf293"
        color: !root.powered ? Theme.fgMuted : root.connectedCount > 0 ? Theme.blue : Theme.fg
        Behavior on color {
            ColorAnimation {
                duration: Theme.animNormal
            }
        }
    }
    BarText {
        visible: root.connectedCount > 0
        text: root.connectedCount
        color: Theme.blue
    }

    // For now: click toggles the adapter. A device list popup comes later.
    onClicked: if (root.adapter)
        root.adapter.enabled = !root.adapter.enabled
}
