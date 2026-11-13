import QtQuick
import QtQuick.Layouts
import qs.core

// Hoverable, clickable pill. Children are laid out in a row inside it.
Item {
    id: root

    default property alias content: row.data
    readonly property bool hovered: ma.containsMouse
    property bool active: false
    property color tint: Theme.fg
    property color hoverColor: Theme.alpha(tint, 0.14)
    property int horizontalPadding: 10

    signal clicked(var mouse)
    signal scrolled(var wheel)

    implicitWidth: row.implicitWidth + horizontalPadding * 2
    implicitHeight: Config.barHeight - 14

    scale: ma.pressed ? 0.95 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: Theme.animFast
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.active ? Theme.pressed : root.hovered ? root.hoverColor : "transparent"
        Behavior on color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: m => root.clicked(m)
        onWheel: w => root.scrolled(w)
    }
}
