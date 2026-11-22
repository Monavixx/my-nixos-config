pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Global shortcuts live here once, so multiple bars don't register duplicates.
// Hyprland:  bind = SUPER, M, global, quickshell:dashboard
Singleton {
    id: root

    signal dashboardToggled
    signal powerToggled

    GlobalShortcut {
        name: "dashboard"
        description: "Toggle the control center"
        onPressed: root.dashboardToggled()
    }
    GlobalShortcut {
        name: "notification-dnd"
        description: "Toggle Do Not Disturb"
        onPressed: Notifs.dnd = !Notifs.dnd
    }
    GlobalShortcut {
        name: "notification-dismiss"
        description: "Hide the visible notification popups"
        onPressed: Notifs.dismissPopups()
    }
    GlobalShortcut {
        name: "power"
        description: "Toggle the power menu"
        onPressed: root.powerToggled()
    }
}
