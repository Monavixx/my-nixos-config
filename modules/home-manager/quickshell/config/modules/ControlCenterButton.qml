import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.core
import qs.components
import qs.services

BarButton {
    id: root

    required property var targetScreen
    active: panel.open

    // Only the bar on the focused monitor reacts to the shortcut
    readonly property bool onFocusedScreen: Hyprland.focusedMonitor === Hyprland.monitorFor(targetScreen)

    BarIcon {
        text: "\uf1de"
        color: root.active ? Theme.accent : Theme.fg
        Behavior on color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }

        Rectangle {
            visible: Notifs.unread > 0
            width: 9
            height: 9
            radius: 4.5
            color: Theme.peach
            border.width: 2
            border.color: Theme.mantle
            anchors {
                top: parent.top
                right: parent.right
                topMargin: -1
                rightMargin: -3
            }
        }
    }
    BarIcon {
        visible: Notifs.dnd
        text: "\uf1f6"
        color: Theme.mauve
        font.pixelSize: Config.fontSize
    }

    onClicked: panel.toggle()

    Connections {
        target: Shortcuts
        function onDashboardToggled() {
            if (root.onFocusedScreen)
                panel.toggle();
        }
    }

    ControlCenter {
        id: panel
        anchorItem: root
    }
}
