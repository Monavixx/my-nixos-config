import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.core
import qs.services

// One notification. `popup: true` adds the auto-hide countdown (paused on hover).
Rectangle {
    id: root

    required property var notif
    property bool popup: false

    readonly property bool critical: notif.urgency === NotificationUrgency.Critical
    readonly property color tint: critical ? Theme.red : Theme.accent
    // Critical notifications stay until dismissed
    // A timeout the app asks for is honored even for critical ones;
    // otherwise critical stays (or uses notifCriticalTimeout) and the rest use the default
    // The spec says milliseconds, but some values arrive unconverted: anything >= 100
    // is read as milliseconds, smaller values as seconds
    readonly property real requested: notif.expireTimeout >= 100 ? notif.expireTimeout / 1000 : notif.expireTimeout
    readonly property real timeout: requested > 0 ? requested : (critical ? Config.notifCriticalTimeout : Config.notifTimeout)
    readonly property var extraActions: notif.actions.filter(a => a.identifier !== "default")
    readonly property string age: popup ? "" : Notifs.age(notif)

    readonly property string iconSource: {
        const _ready = DesktopEntries.applications.values.length;   // re-run once the app list has loaded
        const name = notif.appName || "";
        const candidates = [];

        const ic = notif.appIcon;
        if (ic) {
            if (ic.startsWith("/"))
                return "file://" + ic;
            if (ic.startsWith("file:") || ic.startsWith("image:"))
                return ic;
            candidates.push(ic);
        }

        // The desktop entry the app names (or best guess from its name) knows its icon
        const entry = DesktopEntries.heuristicLookup(notif.desktopEntry || name);
        if (entry && entry.icon)
            candidates.push(entry.icon);

        candidates.push(name, name.toLowerCase(), name.toLowerCase().replace(/\s+/g, "-"));

        for (const c of candidates) {
            if (!c)
                continue;
            if (c.startsWith("/"))
                return "file://" + c;
            const p = Quickshell.iconPath(c, true);
            if (p)
                return p;
        }
        return "";
    }

    property real progress: 1
    property bool imageFailed: false
    readonly property bool useImage: notif.image !== "" && !imageFailed

    implicitHeight: content.implicitHeight + 24 + (popup && timeout > 0 ? 4 : 0)
    radius: 16
    color: Theme.panel
    border.width: 1
    border.color: critical ? Theme.alpha(Theme.red, 0.6) : Theme.glassBorder

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

    HoverHandler {
        id: hover
        onHoveredChanged: if (hovered)
            Notifs.markSeen(root.notif)
    }

    // Left click: run the default action (if any) and hide. Right/middle click: dismiss.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: m => {
            if (m.button === Qt.LeftButton) {
                const d = root.notif.actions.find(a => a.identifier === "default");
                if (d) {
                    d.invoke();
                    Notifs.hidePopup(root.notif);
                } else if (root.popup) {
                    Notifs.hidePopup(root.notif);
                }
            } else {
                Notifs.dismiss(root.notif);
            }
        }
    }

    // Countdown; hovering the card pauses it
    NumberAnimation on progress {
        id: countdown
        from: 1
        to: 0
        duration: Math.max(1, root.timeout * 1000)
        running: root.popup && root.timeout > 0
        paused: hover.hovered
        onFinished: Notifs.hidePopup(root.notif)
    }
    Connections {
        target: Notifs
        function onPopupTouched(n) {
            if (n === root.notif) {
                root.progress = 1;
                countdown.restart();
            }
        }
    }

    Rectangle {
        visible: root.popup && root.timeout > 0
        x: 16
        y: root.height - 7
        width: (root.width - 32) * root.progress
        height: 2
        radius: 1
        color: Theme.alpha(root.tint, 0.7)
    }

    RowLayout {
        id: content
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 12

        ClippingRectangle {
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            Layout.alignment: Qt.AlignTop
            radius: 12
            color: Theme.surface0

            Image {
                id: icon
                anchors.fill: parent
                source: root.useImage ? root.notif.image : root.iconSource
                onStatusChanged: {
                    if (Config.notifDebug)
                        console.log("[notif] icon", root.notif.appName, source, "status=" + status);
                    if (status === Image.Error && root.useImage)
                        root.imageFailed = true;
                }
                sourceSize.width: 96
                sourceSize.height: 96
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
            BarIcon {
                anchors.centerIn: parent
                visible: icon.status !== Image.Ready
                text: "\uf0f3"
                color: root.tint
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                BarText {
                    Layout.fillWidth: true
                    text: root.notif.appName
                    color: Theme.fgMuted
                    font.pixelSize: Config.fontSize - 3
                    elide: Text.ElideRight
                }
                BarText {
                    visible: root.age !== ""
                    text: root.age
                    color: Theme.fgMuted
                    font.pixelSize: Config.fontSize - 3
                }
                Rectangle {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20
                    radius: 10
                    opacity: hover.hovered ? 1 : 0
                    color: closeMa.containsMouse ? Theme.alpha(Theme.red, 0.25) : "transparent"
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.animFast
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animFast
                        }
                    }

                    BarIcon {
                        anchors.centerIn: parent
                        text: "\uf00d"
                        font.pixelSize: Config.fontSize - 3
                        color: closeMa.containsMouse ? Theme.red : Theme.fgDim
                    }
                    MouseArea {
                        id: closeMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Notifs.dismiss(root.notif)
                    }
                }
            }

            BarText {
                Layout.fillWidth: true
                text: root.notif.summary
                font.bold: true
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            BarText {
                Layout.fillWidth: true
                visible: text !== ""
                text: root.notif.body
                textFormat: Text.StyledText
                color: Theme.fgDim
                font.pixelSize: Config.fontSize - 1
                wrapMode: Text.Wrap
                maximumLineCount: root.popup ? 4 : 3
                elide: Text.ElideRight
                onLinkActivated: link => Qt.openUrlExternally(link)
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4
                visible: root.extraActions.length > 0
                spacing: 6

                Repeater {
                    model: root.extraActions

                    delegate: Rectangle {
                        id: btn
                        required property var modelData

                        Layout.fillWidth: true
                        implicitHeight: 28
                        radius: 14
                        color: btnMa.containsMouse ? Theme.alpha(root.tint, 0.25) : Theme.capsule
                        border.width: 1
                        border.color: Theme.capsuleBorder
                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.animFast
                            }
                        }

                        BarText {
                            anchors.centerIn: parent
                            width: parent.width - 16
                            horizontalAlignment: Text.AlignHCenter
                            text: btn.modelData.text
                            font.pixelSize: Config.fontSize - 1
                            elide: Text.ElideRight
                        }
                        MouseArea {
                            id: btnMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                btn.modelData.invoke();
                                if (root.popup)
                                    Notifs.hidePopup(root.notif);
                            }
                        }
                    }
                }
            }
        }
    }
}
