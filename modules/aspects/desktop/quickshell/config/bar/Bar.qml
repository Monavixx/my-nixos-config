import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.core
import qs.components
import qs.modules

PanelWindow {
    id: bar

    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Config.barHeight
    color: "transparent"

    // Namespace used by the Hyprland layerrules (blur).
    WlrLayershell.namespace: "qs-bar"

    // ── glass background ──
    Rectangle {
        anchors.fill: parent
        color: Theme.glass

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Theme.highlightTop
                }
                GradientStop {
                    position: 1.0
                    color: Theme.highlightBottom
                }
            }
        }
        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 1
            color: Theme.glassBorder
        }
    }

    // ── left: workspaces + window title ──
    RowLayout {
        anchors {
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }
        spacing: 12

        Workspaces {
            id: workspaces
            targetScreen: bar.screen
        }
    }

    // ── center: window title ──
    WindowTitle {
        anchors.centerIn: parent
        // Never grow into the left or right groups
        width: Math.min(implicitWidth, bar.width - 2 * Math.max(workspaces.width, rightRow.width) - 80)
    }

    // ── right: tray, status, power ──
    RowLayout {
        id: rightRow
        anchors {
            right: parent.right
            rightMargin: 12
            verticalCenter: parent.verticalCenter
        }
        spacing: 8

        Capsule {
            VolumeWidget {}
            Loader {
                active: Host.isLaptop
                visible: active
                sourceComponent: BatteryWidget {}
            }
            KeyboardWidget {}
            // BluetoothWidget {}
            NetworkWidget {}
            ControlCenterButton {
                targetScreen: bar.screen
            }
        }

        Tray {}
        Capsule {
            ClockWidget {}
        }
        Capsule {
            PowerWidget {}
        }
    }
}
