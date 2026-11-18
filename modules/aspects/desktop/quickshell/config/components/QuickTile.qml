import QtQuick
import QtQuick.Layouts
import qs.core

Rectangle {
    id: root

    property string glyph
    property string label
    property bool on: false
    property color onColor: Theme.accent
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: 58
    radius: 14
    color: on ? onColor : ma.containsMouse ? Theme.hover : Theme.capsule
    border.width: 1
    border.color: on ? "transparent" : Theme.capsuleBorder
    scale: ma.pressed ? 0.96 : 1.0

    Behavior on color { ColorAnimation { duration: Theme.animNormal } }
    Behavior on scale { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 3
        BarIcon {
            Layout.alignment: Qt.AlignHCenter
            text: root.glyph
            color: root.on ? Theme.crust : Theme.fg
        }
        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: root.label
            font.pixelSize: Config.fontSize - 2
            color: root.on ? Theme.crust : Theme.fgDim
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
