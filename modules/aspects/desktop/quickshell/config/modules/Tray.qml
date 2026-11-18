import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.core
import qs.components

Capsule {
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        delegate: BarButton {
            id: btn
            required property var modelData

            implicitWidth: 30

            onClicked: m => {
                if (m.button === Qt.LeftButton) {
                    if (modelData.onlyMenu && modelData.hasMenu) menu.open()
                    else modelData.activate()
                } else if (m.button === Qt.MiddleButton) {
                    modelData.secondaryActivate()
                } else if (m.button === Qt.RightButton && modelData.hasMenu) {
                    menu.open()
                }
            }

            IconImage {
                implicitSize: 18
                source: btn.modelData.icon
            }

            // NOTE: this is the platform menu (not themed). We'll replace it with a glass menu later.
            QsMenuAnchor {
                id: menu
                menu: btn.modelData.menu
                anchor.item: btn
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
            }
        }
    }
}
