import QtQuick
import QtQuick.Layouts
import qs.core

// A subtle rounded group that holds several bar buttons.
Rectangle {
    id: root

    default property alias content: layout.data
    property int padding: 4

    implicitWidth: layout.implicitWidth + padding * 2
    implicitHeight: Config.barHeight - 10
    radius: height / 2
    color: Theme.capsule
    border.width: 1
    border.color: Theme.capsuleBorder

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 2
    }
}
