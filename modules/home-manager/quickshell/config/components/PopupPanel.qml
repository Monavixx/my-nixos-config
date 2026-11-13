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

    property bool closeOnLeave: true      // set to false on a popup to opt out
    property bool hasHovered: false       // true once the mouse has been over the popup

    onOpenChanged: if (open)
        hasHovered = false

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
    // new property, next to contentHeight
    property int windowHeight: contentHeight

    // replace the implicitHeight line
    implicitHeight: windowHeight + gap

    // new line, right under `color: "transparent"` (clicks pass through the empty area)
    mask: Region {
        item: frame
    }
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
    // Small grace period so a brief slip out of the popup doesn't close it
    Timer {
        id: leaveTimer
        interval: 10
        onTriggered: {
            if (root.open && root.hasHovered && !hover.hovered && !press.active)
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
        Behavior on height {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        // Escape: the popup holds keyboard focus (via the focus grab), so apps never see it
        focus: true
        Keys.onEscapePressed: root.open = false

        HoverHandler {
            id: hover
            onHoveredChanged: {
                if (hovered) {
                    root.hasHovered = true;
                    leaveTimer.stop();
                } else if (root.hasHovered && root.closeOnLeave) {
                    leaveTimer.restart();
                }
            }
        }

        // Don't close while a button is held, so dragging a slider out of the popup is safe
        PointHandler {
            id: press
            acceptedButtons: Qt.AllButtons
            onActiveChanged: {
                if (!active && !hover.hovered && root.hasHovered && root.closeOnLeave)
                    leaveTimer.restart();
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
