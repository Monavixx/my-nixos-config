import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.core

// Reusable dropdown under a bar item: fades + slides in, closes on outside click.
// Usage:  PopupPanel { anchorItem: someItem; contentWidth: 300; contentHeight: 200; <children> }
PopupWindow {
    id: root

    property Item anchorItem
    property bool open: false
    property real closedAt: 0
    property int contentWidth: 280
    property int contentHeight: 300
    readonly property int gap: 8

    default property alias content: body.data

    // Toggle that survives the "click on the button that also dismisses the grab" race.
    function toggle() {
        if (open)
            open = false;
        else if (Date.now() - closedAt > 250)
            open = true;
    }

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    implicitWidth: contentWidth
    implicitHeight: contentHeight + gap
    visible: open || frame.opacity > 0.01
    color: "transparent"

    HyprlandFocusGrab {
        windows: [root]
        active: root.open
        onCleared: {
            root.closedAt = Date.now();
            root.open = false;
        }
    }

    Rectangle {
        id: frame
        width: root.contentWidth
        height: root.contentHeight
        y: root.gap + (root.open ? 0 : -10)
        opacity: root.open ? 1 : 0
        radius: 18
        color: Theme.panel
        border.width: 1
        border.color: Theme.glassBorder

        Behavior on opacity {
            NumberAnimation {
                duration: 170
                easing.type: Easing.OutCubic
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Theme.highlightTop
                }
                GradientStop {
                    position: 0.5
                    color: Theme.highlightBottom
                }
            }
        }

        Item {
            id: body
            anchors.fill: parent
            anchors.margins: 14
        }
    }
}
