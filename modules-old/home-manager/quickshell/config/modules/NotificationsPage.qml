import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.core
import qs.components
import qs.services

SubPage {
    id: root

    name: "notifications"
    title: "Notifications" + (Notifs.count > 0 ? "  ·  " + Notifs.count : "")

    onShownChanged: if (shown) Notifs.markRead()

    onKeyPressed: event => {
        if (event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier)) return
        if (event.key === Qt.Key_D) Notifs.dnd = !Notifs.dnd
        else if (event.key === Qt.Key_C) Notifs.clearAll()
        else return
        event.accepted = true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        QuickTile {
            glyph: Notifs.dnd ? "\uf1f6" : "\uf0f3"
            label: "Do not disturb"
            on: Notifs.dnd
            onColor: Theme.mauve
            onClicked: Notifs.dnd = !Notifs.dnd
        }
        QuickTile {
            glyph: "\uf1f8"
            label: "Clear all"
            onClicked: Notifs.clearAll()
        }
    }

    ListView {
        id: list
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(contentHeight, 300)
        visible: Notifs.count > 0
        clip: true
        spacing: 8
        boundsBehavior: Flickable.StopAtBounds

        model: ScriptModel { values: Notifs.history }

        delegate: NotificationCard {
            required property var modelData
            notif: modelData
            width: list.width
        }

        remove: Transition {
            NumberAnimation { property: "opacity"; to: 0; duration: 160 }
        }
        displaced: Transition {
            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
        }
    }

    BarText {
        Layout.fillWidth: true
        visible: Notifs.count > 0
        text: "D do not disturb  ·  C clear all  ·  right-click dismisses"
        horizontalAlignment: Text.AlignHCenter
        color: Theme.fgMuted
        font.pixelSize: Config.fontSize - 3
        elide: Text.ElideRight
    }

    // empty state
    ColumnLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 84
        visible: Notifs.count === 0
        spacing: 6

        Item { Layout.fillHeight: true }
        BarIcon {
            Layout.alignment: Qt.AlignHCenter
            text: "\uf0f3"
            color: Theme.fgMuted
            font.pixelSize: Config.fontSize + 12
        }
        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: "No notifications"
            color: Theme.fgDim
        }
        Item { Layout.fillHeight: true }
    }
}
