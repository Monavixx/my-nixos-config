import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.core
import qs.services

// Session lock (ext-session-lock): while `locked`, the compositor only shows our surfaces
// and sends input only to them.
// Start it with:  qs ipc call lock lock      or      bind = SUPER, L, global, quickshell:lock
Scope {
    id: root

    function engage() {
        if (sessionLock.locked) return
        Wallpaper.refreshState()       // the background follows the current wallpaper
        LockAuth.reset()
        sessionLock.locked = true
    }

    WlSessionLock {
        id: sessionLock
        locked: false

        // One surface per screen
        WlSessionLockSurface {
            id: surface
            color: Theme.crust          // opaque, so nothing flashes before our content fades in

            LockScreen {
                anchors.fill: parent
                targetScreen: surface.screen
            }
        }
    }

    // Unlocking happens only after PAM said yes. There is deliberately no IPC "unlock".
    Connections {
        target: LockAuth
        function onSucceeded() { unlockTimer.start() }
    }
    Timer {
        id: unlockTimer
        interval: 220                   // let the fade-out finish
        onTriggered: {
            sessionLock.locked = false
            LockAuth.finish()
        }
    }

    IpcHandler {
        target: "lock"
        function lock(): void { root.engage() }
        function isLocked(): bool { return sessionLock.locked }
    }

    GlobalShortcut {
        name: "lock"
        description: "Lock the screen"
        onPressed: root.engage()
    }
}
