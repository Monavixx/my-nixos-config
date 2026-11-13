import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.core
import qs.components
import qs.services

SubPage {
    id: root

    name: "wallpaper"
    title: "Wallpaper"

    onShownChanged: if (shown) {
        Wallpaper.scan()
        Wallpaper.refreshState()
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        QuickTile {
            glyph: "\uf074"
            label: "Random"
            onClicked: Wallpaper.random()
        }
        QuickTile {
            glyph: "\uf017"
            label: "Auto-change"
            on: Wallpaper.timerActive
            onColor: Theme.green
            onClicked: Wallpaper.toggleTimer()
        }
    }

    GridView {
        id: grid
        Layout.fillWidth: true
        Layout.preferredHeight: 250
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        cellWidth: Math.floor(width / 3)
        cellHeight: Math.round(cellWidth * 0.64)
        model: Wallpaper.files

        delegate: Item {
            id: cell
            required property string modelData
            readonly property bool isCurrent: Wallpaper.current === modelData

            width: grid.cellWidth
            height: grid.cellHeight

            ClippingRectangle {
                anchors.fill: parent
                anchors.margins: 3
                radius: 10
                color: Theme.surface0
                border.width: cell.isCurrent ? 2 : 0
                border.color: Theme.accent
                scale: ma.containsMouse ? 1.04 : 1.0
                Behavior on scale { NumberAnimation { duration: Theme.animFast; easing.type: Easing.OutCubic } }

                Image {
                    anchors.fill: parent
                    source: Wallpaper.toUrl(cell.modelData)
                    sourceSize.width: 240
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Wallpaper.set(cell.modelData)
                }
            }
        }
    }

    BarText {
        Layout.fillWidth: true
        visible: Wallpaper.files.length === 0 && !Wallpaper.scanning
        text: "No images found in " + Config.wallpaperDir
        color: Theme.fgMuted
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
    }
}
