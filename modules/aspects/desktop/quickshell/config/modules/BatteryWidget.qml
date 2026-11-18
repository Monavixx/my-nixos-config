import QtQuick
import Quickshell.Services.UPower
import qs.core
import qs.components

BarButton {
    id: root

    readonly property var dev: UPower.displayDevice
    readonly property real pct: dev ? dev.percentage : 0     // 0..1
    readonly property bool charging: dev
        && (dev.state === UPowerDeviceState.Charging || dev.state === UPowerDeviceState.FullyCharged)

    visible: dev && dev.isPresent

    BarIcon {
        text: root.pct > 0.875 ? "\uf240" : root.pct > 0.625 ? "\uf241"
            : root.pct > 0.375 ? "\uf242" : root.pct > 0.125 ? "\uf243" : "\uf244"
        color: root.charging ? Theme.green : root.pct <= 0.15 ? Theme.red : root.pct <= 0.30 ? Theme.peach : Theme.fg
        Behavior on color { ColorAnimation { duration: Theme.animNormal } }
    }
    BarIcon {
        visible: root.charging
        text: "\uf0e7"
        color: Theme.green
        font.pixelSize: Config.fontSize
    }
    BarText { text: Math.round(root.pct * 100) + "%" }
}
