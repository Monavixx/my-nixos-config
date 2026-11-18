pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared state for the quick toggles (so multiple bars never fight).
Singleton {
    id: root

    property bool caffeine: false
    property bool wifi: false

    function refreshWifi() { if (!wifiQuery.running) wifiQuery.running = true }
    function toggleWifi() {
        wifiSet.command = ["nmcli", "radio", "wifi", root.wifi ? "off" : "on"]
        wifiSet.running = true
    }

    // Holding a systemd idle inhibitor == "caffeine" (hypridle honors it by default).
    Process {
        running: root.caffeine
        command: ["systemd-inhibit", "--what=idle", "--who=quickshell",
                  "--why=Caffeine toggle", "sleep", "infinity"]
    }

    Process {
        id: wifiQuery
        command: ["nmcli", "radio", "wifi"]
        stdout: StdioCollector { onStreamFinished: root.wifi = text.trim() === "enabled" }
    }

    Process {
        id: wifiSet
        onRunningChanged: if (!running) root.refreshWifi()
    }

    Component.onCompleted: refreshWifi()
}
