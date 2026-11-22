import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.core
import qs.components

PopupPanel {
    id: root

    contentWidth: 340
    contentHeight: 94

    function execute(command) {
        root.open = false;
        Quickshell.execDetached(command);
    }

    component ActionButton: Rectangle {
        id: action

        property string glyph
        property string label
        property color actionColor: Theme.accent
        readonly property bool hovered: ma.containsMouse
        signal clicked

        implicitWidth: 56
        implicitHeight: 62
        radius: 14
        color: action.hovered ? Theme.alpha(action.actionColor, 0.18) : Theme.capsule
        border.width: 1
        border.color: action.hovered ? Theme.alpha(action.actionColor, 0.35) : Theme.capsuleBorder
        scale: ma.pressed ? 0.94 : 1.0

        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }
        Behavior on scale { NumberAnimation { duration: Theme.animFast } }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 5

            BarIcon {
                Layout.alignment: Qt.AlignHCenter
                text: action.glyph
                color: action.hovered ? action.actionColor : Theme.fg
                Behavior on color { ColorAnimation { duration: Theme.animFast } }
            }
            BarText {
                Layout.alignment: Qt.AlignHCenter
                text: action.label
                color: action.hovered ? action.actionColor : Theme.fgDim
                font.pixelSize: Config.fontSize - 3
                Behavior on color { ColorAnimation { duration: Theme.animFast } }
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: action.clicked()
        }
    }

    ColumnLayout {
        width: parent.width
        spacing: 10

        BarText {
            Layout.fillWidth: true
            text: "Power"
            font.bold: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            ActionButton {
                glyph: "\uf023"
                label: "Lock"
                actionColor: Theme.blue
                onClicked: root.execute(["qs", "ipc", "call", "lock", "lock"])
            }
            ActionButton {
                glyph: "\uf2f5"
                label: "Log out"
                actionColor: Theme.peach
                onClicked: root.execute(["sh", "-c", "command -v uwsm >/dev/null 2>&1 && uwsm stop || hyprctl dispatch 'hl.dsp.exit()'"])
            }
            ActionButton {
                glyph: "\uf186"
                label: "Suspend"
                actionColor: Theme.mauve
                onClicked: root.execute(["systemctl", "suspend"])
            }
            ActionButton {
                glyph: "\uf2f1"
                label: "Reboot"
                actionColor: Theme.yellow
                onClicked: root.execute(["systemctl", "reboot"])
            }
            ActionButton {
                glyph: "\uf011"
                label: "Shut down"
                actionColor: Theme.red
                onClicked: root.execute(["systemctl", "poweroff"])
            }
        }
    }
}
