pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Global shortcuts live here once, so multiple bars don't register duplicates.
// Hyprland:  bind = SUPER, M, global, quickshell:dashboard
Singleton {
    id: root

    signal dashboardToggled()

    GlobalShortcut {
        name: "dashboard"
        description: "Toggle the control center"
        onPressed: root.dashboardToggled()
    }
}
