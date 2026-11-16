import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.core
import qs.components
import qs.services

// Floating notification stack, top right under the bar. One per screen,
// but only the focused monitor shows it.
PanelWindow {
    id: win

    required property var modelData
    screen: modelData

    readonly property bool focusedScreen:
        Quickshell.screens.length <= 1 || Hyprland.focusedMonitor === Hyprland.monitorFor(modelData)

    anchors { top: true; right: true; bottom: true }
    margins { top: Config.barHeight + 8; right: 12 }
    implicitWidth: 380
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    visible: focusedScreen

    WlrLayershell.namespace: "qs-notifications"
    WlrLayershell.layer: WlrLayer.Overlay

    // Only the cards take input; the rest of the window is click-through
    mask: Region { item: list }

    ListView {
        id: list
        anchors { top: parent.top; left: parent.left }
        width: 360
        height: contentHeight
        interactive: false
        spacing: 8

        model: ScriptModel { values: Notifs.popups }

        delegate: NotificationCard {
            required property var modelData
            notif: modelData
            popup: true
            width: list.width
        }

        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "x"; from: list.width + 20; duration: 260; easing.type: Easing.OutCubic }
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
            }
        }
        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "x"; to: 40; duration: 200; easing.type: Easing.InCubic }
                NumberAnimation { property: "opacity"; to: 0; duration: 180 }
            }
        }
        displaced: Transition {
            NumberAnimation { property: "y"; duration: 220; easing.type: Easing.OutCubic }
        }
    }
}
