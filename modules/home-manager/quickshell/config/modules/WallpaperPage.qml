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

    property int selectedIndex: -1

    function move(dx, dy) {
        const n = Wallpaper.files.length;
        if (n === 0)
            return;
        const cols = Math.max(1, Math.floor(grid.width / grid.cellWidth));
        let i = selectedIndex;
        if (i < 0) {
            // first press: just show where we are (the current wallpaper)
            i = Math.max(0, Wallpaper.files.indexOf(Wallpaper.current));
        } else {
            i = Math.max(0, Math.min(n - 1, i + dx));
            if (dy !== 0) {
                const t = i + dy * cols;
                if (t >= 0 && t < n)
                    i = t;
                else if (dy > 0 && Math.floor(i / cols) < Math.floor((n - 1) / cols))
                    i = n - 1;
            }
        }
        selectedIndex = i;
        grid.positionViewAtIndex(i, GridView.Contain);
    }

    onKeyPressed: event => {
        if (event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier))
            return;
        switch (event.key) {
        case Qt.Key_Left:
            move(-1, 0);
            break;
        case Qt.Key_Right:
            move(1, 0);
            break;
        case Qt.Key_Up:
            move(0, -1);
            break;
        case Qt.Key_Down:
            move(0, 1);
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (selectedIndex >= 0 && selectedIndex < Wallpaper.files.length)
                Wallpaper.set(Wallpaper.files[selectedIndex]);
            break;
        case Qt.Key_R:
            Wallpaper.random();
            break;
        case Qt.Key_A:
            Wallpaper.toggleTimer();
            break;
        default:
            return;
        }
        event.accepted = true;
    }

    onShownChanged: if (shown) {
        selectedIndex = -1;
        Wallpaper.scan();
        Wallpaper.refreshState();
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
            required property int index
            readonly property bool isSelected: index === root.selectedIndex

            width: grid.cellWidth
            height: grid.cellHeight

            ClippingRectangle {
                anchors.fill: parent
                anchors.margins: 3
                radius: 10
                color: Theme.surface0
                border.width: cell.isCurrent || cell.isSelected ? 2 : 0
                border.color: cell.isSelected ? Theme.text : Theme.accent
                scale: ma.containsMouse || cell.isSelected ? 1.04 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: Theme.animFast
                        easing.type: Easing.OutCubic
                    }
                }

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
        text: "←↑↓→ select  ·  Enter set  ·  R random  ·  A auto"
        horizontalAlignment: Text.AlignHCenter
        color: Theme.fgMuted
        font.pixelSize: Config.fontSize - 3
        elide: Text.ElideRight
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
