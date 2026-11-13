import QtQuick
import QtQuick.Layouts
import qs.core

// A row on the main page that opens a submenu.
Rectangle {
    id: root

    property string glyph
    property string label
    property string detail
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: 42
    radius: 12
    color: ma.containsMouse ? Theme.hover : Theme.capsule
    border.width: 1
    border.color: Theme.capsuleBorder
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    RowLayout {
        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
        spacing: 10

        BarIcon {
            Layout.preferredWidth: 22
            horizontalAlignment: Text.AlignHCenter
            text: root.glyph
            color: Theme.accent
        }
        BarText {
            Layout.fillWidth: true
            text: root.label
        }
        BarText {
            visible: root.detail !== ""
            text: root.detail
            color: Theme.fgMuted
            font.pixelSize: Config.fontSize - 1
        }
        BarIcon {
            text: "\uf054"
            color: Theme.fgMuted
            font.pixelSize: Config.fontSize - 2
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
