import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.core
import qs.components

Rectangle {
    id: root

    property bool active: false       // popup open → keep the position ticking

    // Prefer the player that is actually playing, else the first one
    readonly property var player: {
        const ps = Mpris.players.values;
        return ps.find(p => p.isPlaying) || ps[0] || null;
    }
    // File name without folders or extension, from the xesam:url metadata
    function fileName(p) {
        const url = p.metadata ? p.metadata["xesam:url"] : "";
        if (!url)
            return "";
        try {
            return decodeURIComponent(String(url)).split("/").pop().replace(/\.[^.]+$/, "");
        } catch (e) {
            return "";
        }
    }

    // "Artist - Title", then file name, then the player name
    readonly property string display: {
        if (!player)
            return "";
        const t = player.trackTitle;
        const a = player.trackArtist;
        if (t && a)
            return a + " - " + t;
        return t || a || fileName(player) || player.identity;
    }

    visible: player !== null
    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + 24
    radius: 16
    color: Theme.capsule
    border.width: 1
    border.color: Theme.capsuleBorder

    // MPRIS position doesn't update itself
    Timer {
        running: root.active && root.player !== null && root.player.isPlaying
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }

    ColumnLayout {
        id: content
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 10

        RowLayout {
            spacing: 12

            ClippingRectangle {
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                radius: 12
                color: Theme.surface0

                Image {
                    id: art
                    anchors.fill: parent
                    source: root.player ? root.player.trackArtUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
                BarIcon {
                    anchors.centerIn: parent
                    visible: art.status !== Image.Ready
                    text: "\uf001"
                    color: Theme.fgMuted
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                BarText {
                    Layout.fillWidth: true
                    text: root.display
                    font.bold: true
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
                BarText {
                    Layout.fillWidth: true
                    text: root.player ? root.player.identity : ""
                    color: Theme.fgMuted
                    font.pixelSize: Config.fontSize - 2
                    elide: Text.ElideRight
                }

                RowLayout {
                    spacing: 2
                    BarButton {
                        horizontalPadding: 9
                        opacity: root.player && root.player.canGoPrevious ? 1 : 0.4
                        onClicked: if (root.player)
                            root.player.previous()
                        BarIcon {
                            text: "\uf048"
                        }
                    }
                    BarButton {
                        horizontalPadding: 11
                        onClicked: if (root.player)
                            root.player.togglePlaying()
                        BarIcon {
                            text: root.player && root.player.isPlaying ? "\uf04c" : "\uf04b"
                            color: Theme.accent
                        }
                    }
                    BarButton {
                        horizontalPadding: 9
                        opacity: root.player && root.player.canGoNext ? 1 : 0.4
                        onClicked: if (root.player)
                            root.player.next()
                        BarIcon {
                            text: "\uf051"
                        }
                    }
                }
            }
        }

        GlassSlider {
            Layout.fillWidth: true
            visible: root.player !== null && root.player.lengthSupported && root.player.length > 0
            value: root.player && root.player.length > 0 ? root.player.position / root.player.length : 0
            onMoved: v => {
                if (root.player && root.player.canSeek)
                    root.player.position = v * root.player.length;
            }
        }
    }
}
