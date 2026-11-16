import QtQuick
import QtQuick.Layouts
import qs.core
import qs.components

PopupPanel {
    id: root

    property date viewDate: new Date()
    property date today: new Date()
    readonly property int year: viewDate.getFullYear()
    readonly property int month: viewDate.getMonth()
    // Monday-first grid
    readonly property int offset: (new Date(year, month, 1).getDay() + 6) % 7
    readonly property int daysInMonth: new Date(year, month + 1, 0).getDate()

    contentWidth: 308
    contentHeight: col.implicitHeight + 28

    onOpenChanged: if (open) {
        today = new Date();
        viewDate = new Date();
    }

    function shift(n) {
        viewDate = new Date(year, month + n, 1);
    }

    component NavButton: Rectangle {
        id: nav
        property string glyph
        signal clicked
        implicitWidth: 28
        implicitHeight: 28
        radius: 14
        color: navMa.containsMouse ? Theme.hover : "transparent"
        Behavior on color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }
        BarIcon {
            anchors.centerIn: parent
            text: nav.glyph
            font.pixelSize: Config.fontSize - 1
        }
        MouseArea {
            id: navMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: nav.clicked()
        }
    }

    ColumnLayout {
        id: col
        width: parent.width
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            NavButton {
                glyph: "\uf053"
                onClicked: root.shift(-1)
            }
            BarText {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: Qt.locale().monthName(root.month) + " " + root.year
                font.bold: true
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.viewDate = new Date()
                }
            }
            NavButton {
                glyph: "\uf054"
                onClicked: root.shift(1)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            Repeater {
                model: 7
                delegate: BarText {
                    required property int index
                    Layout.preferredWidth: 40
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.locale().dayName((index + 1) % 7, Locale.ShortFormat).slice(0, 2)
                    color: Theme.fgMuted
                    font.pixelSize: Config.fontSize - 2
                }
            }
        }

        Grid {
            Layout.alignment: Qt.AlignHCenter
            columns: 7
            Repeater {
                model: 42
                delegate: Item {
                    id: dayCell
                    required property int index
                    readonly property int day: index - root.offset + 1
                    readonly property bool valid: day >= 1 && day <= root.daysInMonth
                    readonly property bool isToday: valid && day === root.today.getDate() && root.month === root.today.getMonth() && root.year === root.today.getFullYear()
                    width: 40
                    height: 34

                    Rectangle {
                        anchors.centerIn: parent
                        width: 30
                        height: 30
                        radius: 15
                        color: dayCell.isToday ? Theme.accent : dayMa.containsMouse && dayCell.valid ? Theme.hover : "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.animFast
                            }
                        }
                    }
                    BarText {
                        anchors.centerIn: parent
                        visible: dayCell.valid
                        text: dayCell.day
                        color: dayCell.isToday ? Theme.crust : Theme.fg
                        font.bold: dayCell.isToday
                    }
                    MouseArea {
                        id: dayMa
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }
    }
}
