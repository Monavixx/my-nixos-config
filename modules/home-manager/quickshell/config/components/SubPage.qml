import QtQuick
import QtQuick.Layouts
import qs.core

// Base for control-center submenus. Slides in from the right when `current === name`.
// Usage:  SubPage { name: "foo"; title: "Foo"; current: <router state>; onBack: ...; <children> }
Item {
    id: root

    property string name
    property string title
    property string current
    signal back()

    default property alias content: body.data
    readonly property bool shown: current === name

    width: parent ? parent.width : 0
    height: implicitHeight
    implicitHeight: col.implicitHeight

    x: shown ? 0 : width + 24
    opacity: shown ? 1 : 0
    visible: opacity > 0.01
    enabled: shown

    Behavior on x { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    ColumnLayout {
        id: col
        width: parent.width
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            BarButton {
                horizontalPadding: 9
                onClicked: root.back()
                BarIcon { text: "\uf053" }
            }
            BarText {
                Layout.fillWidth: true
                text: root.title
                font.bold: true
            }
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            spacing: 10
        }
    }
}
