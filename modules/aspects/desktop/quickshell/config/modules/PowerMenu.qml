import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.core
import qs.components
import qs.services

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    readonly property bool focusedScreen: Hyprland.focusedMonitor === Hyprland.monitorFor(modelData)
    readonly property var actions: [
        {
            glyph: "\uf023",
            label: "Lock",
            color: Theme.blue,
            command: ["qs", "ipc", "call", "lock", "lock"]
        },
        {
            glyph: "\uf2f5",
            label: "Log out",
            color: Theme.peach,
            command: ["sh", "-c", "command -v uwsm >/dev/null 2>&1 && uwsm stop || hyprctl dispatch 'hl.dsp.exit()'"]
        },
        {
            glyph: "\uf186",
            label: "Suspend",
            color: Theme.mauve,
            command: ["systemctl", "suspend"]
        },
        {
            glyph: "\uf2f1",
            label: "Reboot",
            color: Theme.yellow,
            command: ["systemctl", "reboot"]
        },
        {
            glyph: "\uf011",
            label: "Shut down",
            color: Theme.red,
            command: ["systemctl", "poweroff"]
        }
    ]

    property int selectedIndex: 0

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    visible: Shortcuts.powerMenuOpen && focusedScreen

    WlrLayershell.namespace: "qs-power-menu"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    function moveSelection(dx, dy) {
        const row = Math.floor(selectedIndex / 3);
        const rowStart = row * 3;
        const rowLength = Math.min(3, actions.length - rowStart);

        if (dx !== 0) {
            selectedIndex = rowStart + (selectedIndex - rowStart + dx + rowLength) % rowLength;
            return;
        }

        const rowCount = Math.ceil(actions.length / 3);
        const nextRow = (row + dy + rowCount) % rowCount;
        const nextRowLength = Math.min(3, actions.length - nextRow * 3);
        selectedIndex = nextRow * 3 + Math.min(selectedIndex % 3, nextRowLength - 1);
    }

    function executeAction(index) {
        const action = actions[index];
        if (!action)
            return;

        Shortcuts.closePowerMenu();
        Quickshell.execDetached(action.command);
    }

    onVisibleChanged: if (visible) {
        selectedIndex = 0;
        Qt.callLater(() => surface.forceActiveFocus());
    }

    Item {
        id: surface
        anchors.fill: parent
        focus: true

        Keys.onPressed: event => {
            switch (event.key) {
            case Qt.Key_Left:
            case Qt.Key_H:
                root.moveSelection(-1, 0);
                break;
            case Qt.Key_Right:
            case Qt.Key_L:
                root.moveSelection(1, 0);
                break;
            case Qt.Key_Up:
            case Qt.Key_K:
                root.moveSelection(0, -1);
                break;
            case Qt.Key_Down:
            case Qt.Key_J:
                root.moveSelection(0, 1);
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
                root.executeAction(root.selectedIndex);
                break;
            case Qt.Key_Escape:
                Shortcuts.closePowerMenu();
                break;
            default:
                return;
            }
            event.accepted = true;
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.alpha(Theme.base, 0.62)
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(parent.width - 48, 640)
            spacing: 26

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                BarText {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Power"
                    font.pixelSize: Config.fontSize + 20
                    font.bold: true
                }
                BarText {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Choose an action"
                    color: Theme.fgDim
                    font.pixelSize: Config.fontSize + 2
                }
            }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter
                columns: 3
                columnSpacing: 18
                rowSpacing: 18

                Repeater {
                    model: root.actions

                    delegate: Rectangle {
                        id: tile
                        required property int index
                        required property var modelData
                        readonly property bool selected: root.selectedIndex === index

                        Layout.preferredWidth: 168
                        Layout.preferredHeight: 150
                        radius: 24
                        color: selected ? Theme.alpha(modelData.color, 0.2) : Theme.alpha(Theme.text, 0.045)
                        border.width: selected ? 2 : 1
                        border.color: selected ? Theme.alpha(modelData.color, 0.78) : Theme.glassBorder
                        scale: ma.pressed ? 0.96 : selected ? 1.025 : 1.0

                        Behavior on color { ColorAnimation { duration: Theme.animFast } }
                        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }
                        Behavior on scale { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 12

                            BarIcon {
                                Layout.alignment: Qt.AlignHCenter
                                text: tile.modelData.glyph
                                color: tile.selected ? tile.modelData.color : Theme.fg
                                font.pixelSize: Config.fontSize + 20
                            }
                            BarText {
                                Layout.alignment: Qt.AlignHCenter
                                text: tile.modelData.label
                                color: tile.selected ? Theme.fg : Theme.fgDim
                                font.pixelSize: Config.fontSize + 2
                                font.bold: tile.selected
                            }
                        }

                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: root.selectedIndex = tile.index
                            onClicked: root.executeAction(tile.index)
                        }
                    }
                }
            }

            BarText {
                Layout.alignment: Qt.AlignHCenter
                text: "←/h   ↓/j   ↑/k   →/l       Enter: select     Esc: cancel"
                color: Theme.fgMuted
                font.pixelSize: Config.fontSize - 1
            }
        }
    }
}
