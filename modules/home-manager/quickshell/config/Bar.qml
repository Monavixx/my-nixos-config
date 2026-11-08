pragma ComponentBehavior: Bound
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell
import QtQuick
import Quickshell.Hyprland

Scope {
    id: root
    property string time
    Variants {
        model: Quickshell.screens

        Scope {
            id: root2
            // the screen from the screens list will be injected into this
            // property
            required property var modelData

            // we can then set the window's screen to the injected property
            // qmllint disable uncreatable-type
            PanelWindow {
                id: pw
                screen: root2.modelData
                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: 40
                color: "#201e1e2e"
                BackgroundEffect.blurRegion: Region {
                    item: pw.contentItem
                }

                Text {
                    id: clockText
                    anchors.centerIn: parent
                    // text: Qt.formatDateTime(clock.date, "dd-MM-yyyy hh:mm:ss")
                    text: Hyprland.activeToplevel.title

                    color: "#cdd6f4"
                    font.pixelSize: 16
                }
            }
        }
    }
    SystemClock {
        id: clock
        precision: SystemClock.Enum.Seconds
    }
}
