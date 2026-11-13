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

    // Router state: "main" or a submenu name
    property string page: "main"
    property string hint: ""

    // Height of the page being shown / of the tallest page (the window is sized
    // for the tallest one so the frame can animate between heights smoothly)
    readonly property real pageHeight: {
        const kids = viewport.children;
        for (let i = 0; i < kids.length; i++)
            if (kids[i].shown === true)
                return kids[i].implicitHeight;
        return 0;
    }
    readonly property real maxPageHeight: {
        let m = 0;
        const kids = viewport.children;
        for (let i = 0; i < kids.length; i++)
            if (kids[i].shown !== undefined)
                m = Math.max(m, kids[i].implicitHeight);
        return m;
    }

    contentWidth: 340
    contentHeight: pageHeight + 28
    windowHeight: maxPageHeight + 28

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property var adapter: Bluetooth.defaultAdapter

    PwObjectTracker {
        objects: [root.sink]
    }

    onOpenChanged: {
        SystemStats.active = open;
        if (open) {
            Toggles.refreshWifi();
            Wallpaper.refreshState();
            Tasks.refresh();
        }
    }
    // Start on the main page next time (changes while hidden, so nobody sees it)
    onVisibleChanged: if (!visible)
        page = "main"

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

    // All pages live here and slide horizontally
    Item {
        id: viewport
        width: parent.width
        height: root.pageHeight

        // ── main page ──
        Item {
            id: mainPage
            readonly property bool shown: root.page === "main"

            width: parent.width
            height: implicitHeight
            implicitHeight: mainCol.implicitHeight
            x: shown ? 0 : -(width + 24)
            opacity: shown ? 1 : 0
            visible: opacity > 0.01
            enabled: shown

            Behavior on x {
                NumberAnimation {
                    duration: 240
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            ColumnLayout {
                id: mainCol
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
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    CircleButton {
                        glyph: "\uf03e"
                        label: "Wallpaper"
                        badge: Wallpaper.timerActive
                        onClicked: root.page = "wallpaper"
                        onHoveredChanged: root.hint = hovered ? label : ""
                    }
                    CircleButton {
                        glyph: "\uf0ae"
                        label: "Tasks"
                        badge: Tasks.overdue > 0
                        badgeColor: Theme.red
                        onClicked: root.page = "tasks"
                        onHoveredChanged: root.hint = hovered ? label : ""
                    }

                    Item {
                        Layout.fillWidth: true
                    }   // pushes the hint to the right

                    BarText {
                        text: root.hint
                        color: Theme.fgMuted
                        font.pixelSize: Config.fontSize - 1
                    }
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

        // ── submenus (add new pages here) ──
        WallpaperPage {
            current: root.page
            onBack: root.page = "main"
        }
        TasksPage {
            current: root.page
            onBack: root.page = "main"
        }
    }
}
