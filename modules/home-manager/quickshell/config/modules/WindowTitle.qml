import QtQuick
import Quickshell.Wayland
import qs.core
import qs.components

Item {
    id: root

    readonly property var toplevel: ToplevelManager.activeToplevel
    readonly property string title: toplevel && toplevel.title ? toplevel.title : "Desktop"
    property string shown: title

    implicitHeight: Config.barHeight
    implicitWidth: label.implicitWidth

    // Cross-fade when the title changes
    onTitleChanged: swap.restart()
    SequentialAnimation {
        id: swap
        NumberAnimation { target: label; property: "opacity"; to: 0; duration: 90 }
        ScriptAction { script: root.shown = root.title }
        NumberAnimation { target: label; property: "opacity"; to: 1; duration: 150 }
    }

    BarText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        text: root.shown
        elide: Text.ElideRight
        color: Theme.fgDim
    }
}
