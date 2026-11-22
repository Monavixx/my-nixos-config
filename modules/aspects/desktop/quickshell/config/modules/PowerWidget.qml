import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.components
import qs.core
import qs.services

BarButton {
    id: root
    required property var targetScreen

    active: panel.open
    hoverColor: Theme.alpha(Theme.red, 0.22)

    readonly property bool onFocusedScreen: Hyprland.focusedMonitor === Hyprland.monitorFor(targetScreen)

    BarIcon {
        text: "\uf011"
        color: root.active ? Theme.red : root.hovered ? Theme.red : Theme.fg
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
    }

    onClicked: panel.toggle()

    Connections {
        target: Shortcuts
        function onPowerToggled() {
            if (root.onFocusedScreen)
                panel.toggle();
        }
    }

    PowerMenu {
        id: panel
        anchorItem: root
    }
}
