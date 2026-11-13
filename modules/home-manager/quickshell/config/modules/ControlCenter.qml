import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.core
import qs.components
import qs.services

PopupPanel {
    id: root

    contentWidth: 340
    contentHeight: col.implicitHeight + 28

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property var adapter: Bluetooth.defaultAdapter

    PwObjectTracker {
        objects: [root.sink]
    }

    onOpenChanged: {
        SystemStats.active = open;
        if (open)
            Toggles.refreshWifi();
    }

    component StatRing: ColumnLayout {
        id: sr
        property real value: 0
        property color tint: Theme.accent
        property string center: ""
        property string label: ""
        property string detail: ""

        Layout.fillWidth: true
        spacing: 3

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 58
            Layout.preferredHeight: 58
            Ring {
                anchors.fill: parent
                value: sr.value
                tint: sr.tint
            }
            BarText {
                anchors.centerIn: parent
                text: sr.center
                font.pixelSize: Config.fontSize - 2
                font.bold: true
            }
        }
        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: sr.label
            font.pixelSize: Config.fontSize - 1
        }
        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: sr.detail
            color: Theme.fgMuted
            font.pixelSize: Config.fontSize - 3
        }
    }

    ColumnLayout {
        id: col
        width: parent.width
        spacing: 12

        MediaCard {
            active: root.open
        }

        // ── volume ──
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            BarButton {
                horizontalPadding: 8
                onClicked: if (root.sink && root.sink.audio)
                    root.sink.audio.muted = !root.sink.audio.muted
                BarIcon {
                    Layout.preferredWidth: 20
                    horizontalAlignment: Text.AlignHCenter
                    text: root.muted || root.volume < 0.01 ? "\uf026" : root.volume < 0.5 ? "\uf027" : "\uf028"
                    color: root.muted ? Theme.fgMuted : Theme.fg
                }
            }
            GlassSlider {
                Layout.fillWidth: true
                value: root.volume
                tint: root.muted ? Theme.fgMuted : Theme.accent
                onMoved: v => {
                    if (root.sink && root.sink.audio)
                        root.sink.audio.volume = v;
                }
            }
            BarText {
                Layout.preferredWidth: 38
                horizontalAlignment: Text.AlignRight
                text: Math.round(root.volume * 100) + "%"
                color: Theme.fgDim
            }
        }

        // ── quick toggles ──
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            QuickTile {
                glyph: "\uf1eb"
                label: "Wi-Fi"
                on: Toggles.wifi
                onClicked: Toggles.toggleWifi()
            }
            QuickTile {
                glyph: "\uf293"
                label: "Bluetooth"
                on: root.adapter ? root.adapter.enabled : false
                onColor: Theme.blue
                onClicked: if (root.adapter)
                    root.adapter.enabled = !root.adapter.enabled
            }
            // QuickTile {
            //     glyph: "\uf0f4"
            //     label: "Caffeine"
            //     on: Toggles.caffeine
            //     onColor: Theme.peach
            //     onClicked: Toggles.caffeine = !Toggles.caffeine
            // }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.capsuleBorder
        }

        // ── system stats ──
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            StatRing {
                value: SystemStats.cpu
                tint: Theme.blue
                center: Math.round(SystemStats.cpu * 100) + "%"
                label: "CPU"
            }
            StatRing {
                value: SystemStats.memUsed / SystemStats.memTotal
                tint: Theme.mauve
                center: Math.round(SystemStats.memUsed / SystemStats.memTotal * 100) + "%"
                label: "RAM"
                detail: SystemStats.memUsed.toFixed(1) + "/" + SystemStats.memTotal.toFixed(0) + "G"
            }
            StatRing {
                value: SystemStats.temp / 100
                tint: SystemStats.temp >= 80 ? Theme.red : SystemStats.temp >= 60 ? Theme.yellow : Theme.green
                center: SystemStats.temp < 0 ? "--" : Math.round(SystemStats.temp) + "°"
                label: "Temp"
            }
            StatRing {
                value: SystemStats.diskUsed / SystemStats.diskTotal
                tint: Theme.teal
                center: Math.round(SystemStats.diskUsed / SystemStats.diskTotal * 100) + "%"
                label: "Disk"
                detail: SystemStats.diskUsed.toFixed(0) + "/" + SystemStats.diskTotal.toFixed(0) + "G"
            }
        }
    }
}
