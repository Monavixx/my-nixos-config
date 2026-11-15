pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import qs.core

// Authentication state for the lock screen.
// Two independent PAM sessions run side by side: the password one starts when you press
// Enter, the fingerprint one runs the whole time the screen is locked. First success wins.
Singleton {
    id: root

    property bool engaged: false       // the screen is locked
    property bool busy: false          // a password check is running
    property bool unlocking: false     // authenticated; fading out
    property string error: ""
    property string fpMessage: ""
    property bool fpAvailable: true
    property bool capsLock: false
    property string pending: ""        // the password being checked; cleared right after

    readonly property bool fingerprint: Host.isLaptop

    signal failed()
    signal succeeded()

    function reset() {
        error = ""
        pending = ""
        busy = false
        unlocking = false
        fpMessage = ""
        fpAvailable = true
        engaged = true
        if (fingerprint) startFp()
        refreshCaps()
    }

    function finish() {
        engaged = false
        unlocking = false
        stopFp()
    }

    function submit(password) {
        if (busy || unlocking || password.length === 0) return
        pending = password
        error = ""
        busy = true
        if (!pamPw.start()) {
            busy = false
            pending = ""
            error = "Authentication is unavailable"
            failed()
        }
    }

    function succeed() {
        if (unlocking) return
        unlocking = true
        stopFp()
        succeeded()
    }

    function startFp() { if (fpAvailable && !pamFp.active) pamFp.start() }
    function stopFp() {
        retryTimer.stop()
        if (pamFp.active) pamFp.abort()
    }

    function refreshCaps() { if (!capsProc.running) capsProc.running = true }
    function capsKey() { capsTimer.restart() }

    // ── password ──
    PamContext {
        id: pamPw
        config: Config.lockPamPassword

        onPamMessage: {
            if (pamPw.responseRequired) pamPw.respond(root.pending)
        }
        onCompleted: result => {
            root.pending = ""
            root.busy = false
            if (result === PamResult.Success) {
                root.succeed()
            } else {
                root.error = result === PamResult.MaxTries ? "Too many attempts" : "Wrong password"
                root.failed()
            }
        }
        onError: err => {
            root.pending = ""
            root.busy = false
            root.error = "Authentication error"
            root.failed()
        }
    }

    // ── fingerprint ──
    PamContext {
        id: pamFp
        config: Config.lockPamFingerprint

        onPamMessage: root.fpMessage = pamFp.message
        onCompleted: result => {
            if (result === PamResult.Success) {
                root.succeed()
                return
            }
            root.fpMessage = "Fingerprint not recognized"
            if (result === PamResult.Error) root.fpAvailable = false
            else if (root.engaged && !root.unlocking) retryTimer.restart()
        }
        onError: err => {
            root.fpMessage = ""
            root.fpAvailable = false      // no reader or no PAM service: stop retrying
        }
    }

    Timer {
        id: retryTimer
        interval: 800
        onTriggered: if (root.engaged && !root.unlocking) root.startFp()
    }

    // ── caps lock (Hyprland knows the LED state) ──
    Timer { id: capsTimer; interval: 80; onTriggered: root.refreshCaps() }

    Process {
        id: capsProc
        command: ["hyprctl", "devices", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const kbs = JSON.parse(text).keyboards
                    const main = kbs.find(k => k.main) || kbs[0]
                    root.capsLock = !!(main && main.capsLock)
                } catch (e) {}
            }
        }
    }
}
