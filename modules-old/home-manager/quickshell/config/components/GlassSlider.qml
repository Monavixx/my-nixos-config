import QtQuick
import qs.core

Item {
    id: root

    property real value: 0            // 0..1
    property color tint: Theme.accent
    signal moved(real value)

    implicitWidth: 120
    implicitHeight: 22

    readonly property real clamped: Math.max(0, Math.min(1, value))

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 3
        color: Theme.alpha(Theme.text, 0.12)

        Rectangle {
            width: parent.width * root.clamped
            height: parent.height
            radius: parent.radius
            color: root.tint
        }
    }

    Rectangle {
        width: 14
        height: 14
        radius: 7
        anchors.verticalCenter: parent.verticalCenter
        x: root.clamped * (root.width - width)
        color: Theme.text
        scale: ma.pressed ? 1.25 : ma.containsMouse ? 1.1 : 1.0
        Behavior on scale { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        function set(mx) { root.moved(Math.max(0, Math.min(1, mx / width))) }
        onPressed: m => set(m.x)
        onPositionChanged: m => { if (pressed) set(m.x) }
    }
}
