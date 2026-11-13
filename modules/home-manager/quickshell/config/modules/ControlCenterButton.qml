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
    readonly property bool onFocusedScreen:
        Hyprland.focusedMonitor === Hyprland.monitorFor(targetScreen)

    BarIcon {
        text: "\uf1de"
        color: root.active ? Theme.accent : Theme.fg
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
    }

    onClicked: panel.toggle()

    Connections {
        target: Shortcuts
        function onDashboardToggled() { if (root.onFocusedScreen) panel.toggle() }
    }

    ControlCenter {
        id: panel
        anchorItem: root
    }
}
