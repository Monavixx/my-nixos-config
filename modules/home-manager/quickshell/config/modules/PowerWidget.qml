import QtQuick
import Quickshell
import qs.core
import qs.components

BarButton {
    id: root
    hoverColor: Theme.alpha(Theme.red, 0.22)

    BarIcon {
        text: "\uf011"
        color: root.hovered ? Theme.red : Theme.fg
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
    }

    onClicked: Quickshell.execDetached(Config.powerMenu)
}
