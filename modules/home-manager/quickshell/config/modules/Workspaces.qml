import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.core
import qs.components

Rectangle {
    id: root

    required property var targetScreen

    readonly property var monitor: Hyprland.monitorFor(targetScreen)
    readonly property int activeId: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : 1
    readonly property int count: Config.workspaceCount
    readonly property int cell: 32
    readonly property int pad: 4
    property real lastWheel: 0

    function exists(id) {
        return Hyprland.workspaces.values.some(w => w.id === id)
    }

    implicitWidth: count * cell + pad * 2
    implicitHeight: Config.barHeight - 10
    radius: height / 2
    color: Theme.capsule
    border.width: 1
    border.color: Theme.capsuleBorder

    // Sliding active indicator
    Rectangle {
        readonly property bool inRange: root.activeId >= 1 && root.activeId <= root.count
        x: root.pad + (Math.max(1, Math.min(root.count, root.activeId)) - 1) * root.cell + 2
        y: 4
        width: root.cell - 4
        height: root.height - 8
        radius: height / 2
        color: Theme.accent
        opacity: inRange ? 1 : 0

        Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 0.9 } }
        Behavior on opacity { NumberAnimation { duration: Theme.animNormal } }
    }

    Repeater {
        model: root.count

        delegate: Item {
            id: cellItem
            required property int index
            readonly property int wsId: index + 1
            readonly property bool isActive: root.activeId === wsId
            readonly property bool isOccupied: root.exists(wsId)

            x: root.pad + index * root.cell
            width: root.cell
            height: root.height

            Rectangle {
                anchors.centerIn: parent
                width: root.cell - 4
                height: root.height - 8
                radius: height / 2
                color: Theme.hover
                opacity: ma.containsMouse && !cellItem.isActive ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
            }

            BarText {
                anchors.centerIn: parent
                text: cellItem.wsId
                font.bold: cellItem.isActive
                color: cellItem.isActive ? Theme.crust
                     : cellItem.isOccupied ? Theme.fg : Theme.fgMuted
                Behavior on color { ColorAnimation { duration: Theme.animNormal } }
            }

            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + cellItem.wsId)
            }
        }
    }

    WheelHandler {
        onWheel: e => {
            const now = Date.now()
            if (now - root.lastWheel < 120) return
            root.lastWheel = now
            Hyprland.dispatch(e.angleDelta.y > 0 ? "workspace e-1" : "workspace e+1")
        }
    }
}
