import QtQuick
import qs.core

// Small round button that opens a submenu. `badge` shows a green status dot.
Rectangle {
    id: root

    property string glyph
    property string label
    property bool badge: false
    readonly property bool hovered: ma.containsMouse
    signal clicked

    implicitWidth: 38
    implicitHeight: 38
    radius: width / 2
    color: hovered ? Theme.hover : Theme.capsule
    border.width: 1
    border.color: Theme.capsuleBorder
    scale: ma.pressed ? 0.92 : 1.0

    Behavior on color {
        ColorAnimation {
            duration: Theme.animFast
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Theme.animFast
            easing.type: Easing.OutCubic
        }
    }

    BarIcon {
        anchors.centerIn: parent
        text: root.glyph
        color: root.hovered ? Theme.accent : Theme.fg
        Behavior on color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }
    }

    Rectangle {
        visible: root.badge
        width: 9
        height: 9
        radius: 4.5
        color: Theme.green
        border.width: 2
        border.color: Theme.mantle
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 1
            rightMargin: 1
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
