pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.core

// The notification daemon. `popups` are the cards currently floating on screen,
// `history` is everything that hasn't been dismissed yet (newest first).
Singleton {
    id: root

    property bool dnd: false
    property bool starting: true      // true for the first second after (re)load
    property int unread: 0
    property var unseen: ({})          // notification id -> true
    property var touchQueue: []

    // An already-visible popup was updated by its app: restart its countdown
    signal popupTouched(var n)
    property var popups: []           // Notification objects, newest first
    property var arrivals: ({})       // notification id -> arrival time (ms)

    readonly property int count: server.trackedNotifications.values.length
    readonly property var history: {
        const v = server.trackedNotifications.values;
        const out = [];
        for (let i = v.length - 1; i >= 0; i--)
            out.push(v[i]);
        return out;
    }

    // Hides the popup only; the notification stays in the history
    function hidePopup(n) {
        popups = popups.filter(p => p !== n);
    }

    // Removes the notification for good
    function dismiss(n) {
        hidePopup(n);
        n.dismiss();
    }
    function showPopup(n) {
        // Do Not Disturb silences popups, except critical ones
        if (dnd && n.urgency !== NotificationUrgency.Critical)
            return;
        let arr = [n].concat(popups.filter(p => p !== n));
        if (arr.length > Config.notifMaxPopups)
            arr = arr.slice(0, Config.notifMaxPopups);
        popups = arr;
    }

    function dismissPopups() {
        popups.forEach(n => markSeen(n));   // you saw them, so they don't count as unread
        popups = [];
    }

    function clearAll() {
        popups = [];
        const all = history;
        all.forEach(n => n.dismiss());
        markRead();
    }
    // Keeps only the newest Config.notifMaxHistory notifications (values are oldest first)
    function trimHistory() {
        const v = server.trackedNotifications.values;
        const extra = v.length - Config.notifMaxHistory;
        if (extra <= 0)
            return;
        const oldest = [];
        for (let i = 0; i < extra; i++)
            oldest.push(v[i]);
        oldest.forEach(o => dismiss(o));
    }

    function setSeen(id, seen) {
        if (seen)
            delete unseen[id];
        else
            unseen[id] = true;
        unread = Object.keys(unseen).length;
    }
    function markSeen(n) {
        if (unseen[n.id])
            setSeen(n.id, true);
    }
    function markRead() {
        unseen = ({});
        unread = 0;
    }

    // Apps replace notifications in place (progress, status updates). Several properties
    // change together, so collect them briefly and handle the update once.
    function touch(n) {
        if (touchQueue.indexOf(n) < 0)
            touchQueue.push(n);
        touchTimer.restart();
    }
    function refreshPopup(n) {
        if (popups.indexOf(n) >= 0) {
            popupTouched(n);            // visible already: just restart the countdown
            return;
        }
        setSeen(n.id, false);           // it was hidden: bring it back as a new, unread one
        showPopup(n);
    }

    function age(n) {
        const t = arrivals[n.id];
        if (!t)
            return "";
        const s = Math.floor((Date.now() - t) / 1000);
        if (s < 60)
            return "now";
        if (s < 3600)
            return Math.floor(s / 60) + "m";
        if (s < 86400)
            return Math.floor(s / 3600) + "h";
        return Math.floor(s / 86400) + "d";
    }

    NotificationServer {
        id: server

        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        actionsSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: n => {
            n.tracked = true;                 // without this the notification is dropped
            const id = n.id;
            const carried = n.lastGeneration === true || root.starting;
            if (!carried)
                root.arrivals[id] = Date.now();

            n.closed.connect(() => {
                root.hidePopup(n);
                root.touchQueue = root.touchQueue.filter(x => x !== n);
                root.setSeen(id, true);
            });

            const hooks = ["summaryChanged", "bodyChanged", "appIconChanged", "imageChanged", "urgencyChanged", "expireTimeoutChanged", "actionsChanged"];
            hooks.forEach(name => {
                const s = n[name];
                if (s && s.connect)
                    s.connect(() => root.touch(n));
            });
            // Survived a config reload: keep it in the history, but no popup and not unread
            if (carried)
                return;
            if (Config.notifDebug)
                console.log("[notif]", "app=" + n.appName, "icon=" + n.appIcon, "image=" + n.image, "desktop=" + n.desktopEntry, "urgency=" + n.urgency, "timeout=" + n.expireTimeout);

            root.setSeen(id, false);
            root.showPopup(n);
            Qt.callLater(root.trimHistory);
        }
    }
    Timer {
        id: touchTimer
        interval: 40
        onTriggered: {
            const q = root.touchQueue;
            root.touchQueue = [];
            q.forEach(n => root.refreshPopup(n));
        }
    }
    // Carried-over notifications arrive right at startup. This is the safety net in case
    // the lastGeneration flag isn't set.
    Timer {
        running: true
        interval: 1000
        onTriggered: root.starting = false
    }
}
