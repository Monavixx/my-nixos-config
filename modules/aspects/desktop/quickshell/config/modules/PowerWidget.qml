import QtQuick
import Quickshell.Hyprland
import qs.components
import qs.core
import qs.services

BarButton {
    id: root
    required property var targetScreen

    active: Shortcuts.powerMenuOpen && root.onFocusedScreen
    hoverColor: Theme.alpha(Theme.red, 0.22)

    readonly property bool onFocusedScreen: Hyprland.focusedMonitor === Hyprland.monitorFor(targetScreen)

    BarIcon {
        text: root.active ? "\uf00d" : "\uf011"
        color: root.active ? Theme.red : root.hovered ? Theme.red : Theme.fg
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
    }

    onClicked: Shortcuts.togglePowerMenu()
}
