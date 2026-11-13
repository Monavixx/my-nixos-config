import QtQuick
import Quickshell
import qs.core
import qs.components

BarButton {
    id: root
    active: calendar.open

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    BarText {
        text: Qt.formatDateTime(clock.date, "ddd d MMM")
        color: Theme.fgDim
    }
    BarText {
        text: Qt.formatDateTime(clock.date, "h:mm AP")
        font.bold: true
    }

    onClicked: calendar.toggle()

    CalendarPopup {
        id: calendar
        anchorItem: root
    }
}
