import QtQuick
import QtQuick.Layouts
import qs.core
import qs.components
import qs.services

SubPage {
    id: root

    name: "timers"
    title: "Timers & Alarms" + (Timers.count > 0 ? "  ·  " + Timers.count : "")

    function formatDuration(seconds) {
        const total = Math.max(0, Math.ceil(seconds));
        const hours = Math.floor(total / 3600);
        const minutes = Math.floor((total % 3600) / 60);
        const remainder = total % 60;
        if (hours > 0)
            return hours + ":" + String(minutes).padStart(2, "0") + ":" + String(remainder).padStart(2, "0");
        return minutes + ":" + String(remainder).padStart(2, "0");
    }

    function addTimer() {
        if (!durationInput.acceptableInput)
            return;
        Timers.addTimer(Number(durationInput.text) * 60, timerLabel.text.trim() || "Timer");
        durationInput.text = "";
        timerLabel.text = "";
    }

    function addAlarm() {
        if (!alarmTime.acceptableInput)
            return;
        const parts = alarmTime.text.split(":");
        const now = new Date();
        const date = new Date(now.getFullYear(), now.getMonth(), now.getDate(), Number(parts[0]), Number(parts[1]), 0, 0);
        if (date.getTime() <= now.getTime())
            date.setDate(date.getDate() + 1);
        Timers.addAlarm(date.getTime() / 1000, alarmLabel.text.trim() || "Alarm");
        alarmTime.text = "";
        alarmLabel.text = "";
    }

    function handleTab(event) {
        if (event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier))
            return;
        if (event.key !== Qt.Key_Tab && event.key !== Qt.Key_Backtab)
            return;

        const fields = [durationInput, timerLabel, alarmTime, alarmLabel];
        let current = -1;
        for (let i = 0; i < fields.length; i++) {
            if (fields[i].focused) {
                current = i;
                break;
            }
        }

        const backwards = event.key === Qt.Key_Backtab || (event.modifiers & Qt.ShiftModifier);
        const next = current < 0
            ? (backwards ? fields.length - 1 : 0)
            : (current + (backwards ? fields.length - 1 : 1)) % fields.length;
        fields[next].focusInput();
        event.accepted = true;
    }

    onKeyPressed: event => handleTab(event)

    component PillInput: Rectangle {
        id: pill
        property alias text: field.text
        property alias acceptableInput: field.acceptableInput
        property string placeholder
        property bool durationMode: false
        property bool timeMode: false
        readonly property bool focused: field.activeFocus

        signal tabPressed(var event)
        signal enterPressed(var event)

        function focusInput() {
            field.forceActiveFocus();
        }

        implicitHeight: 36
        radius: 18
        color: Theme.capsule
        border.width: 1
        border.color: field.activeFocus ? Theme.accent : Theme.capsuleBorder

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }

        DoubleValidator {
            id: durationValidator
            bottom: 0.01
            decimals: 2
        }
        RegularExpressionValidator {
            id: timeValidator
            regularExpression: /^([01][0-9]|2[0-3]):[0-5][0-9]$/
        }

        TextInput {
            id: field
            anchors {
                fill: parent
                leftMargin: 12
                rightMargin: 12
            }
            clip: true
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Config.fontSize - 1
            selectionColor: Theme.accent
            selectedTextColor: Theme.crust
            verticalAlignment: TextInput.AlignVCenter
            validator: pill.timeMode ? timeValidator : pill.durationMode ? durationValidator : null
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    pill.enterPressed(event);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab) {
                    pill.tabPressed(event);
                    event.accepted = true;
                }
            }
        }

        BarText {
            anchors {
                left: parent.left
                leftMargin: 12
                verticalCenter: parent.verticalCenter
            }
            visible: field.text.length === 0
            text: pill.placeholder
            color: Theme.fgMuted
            font.pixelSize: Config.fontSize - 2
            elide: Text.ElideRight
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        PillInput {
            id: durationInput
            Layout.preferredWidth: 86
            placeholder: "Minutes"
            durationMode: true
            onTabPressed: event => root.handleTab(event)
            onEnterPressed: event => root.addTimer()
        }
        PillInput {
            id: timerLabel
            Layout.fillWidth: true
            placeholder: "Timer name"
            onTabPressed: event => root.handleTab(event)
            onEnterPressed: event => root.addTimer()
        }
        BarButton {
            horizontalPadding: 8
            enabled: durationInput.acceptableInput
            onClicked: root.addTimer()
            BarIcon { text: "\uf067" }
        }
    }

    ListView {
        id: timerList
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(contentHeight, 150)
        visible: Timers.timers.length > 0
        clip: true
        spacing: 2
        boundsBehavior: Flickable.StopAtBounds
        model: Timers.timers

        delegate: Rectangle {
            id: timerRow
            required property var modelData
            width: timerList.width
            height: 46
            radius: 12
            color: timerHover.hovered ? Theme.hover : "transparent"

            HoverHandler { id: timerHover }

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 6
                }
                spacing: 6

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    BarText {
                        Layout.fillWidth: true
                        text: timerRow.modelData.label
                        elide: Text.ElideRight
                    }
                    BarText {
                        text: timerRow.modelData.status === "paused"
                            ? "Paused · " + root.formatDuration(timerRow.modelData.remaining)
                            : root.formatDuration(timerRow.modelData.remaining) + " remaining"
                        color: Theme.fgMuted
                        font.pixelSize: Config.fontSize - 3
                    }
                }

                BarButton {
                    horizontalPadding: 6
                    onClicked: timerRow.modelData.status === "paused"
                        ? Timers.resume(timerRow.modelData.id) : Timers.pause(timerRow.modelData.id)
                    BarIcon { text: timerRow.modelData.status === "paused" ? "\uf04b" : "\uf04c" }
                }
                BarButton {
                    horizontalPadding: 6
                    tint: Theme.red
                    onClicked: Timers.remove(timerRow.modelData.id)
                    BarIcon { text: "\uf1f8" }
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        PillInput {
            id: alarmTime
            Layout.preferredWidth: 86
            placeholder: "HH:MM"
            timeMode: true
            onTabPressed: event => root.handleTab(event)
            onEnterPressed: event => root.addAlarm()
        }
        PillInput {
            id: alarmLabel
            Layout.fillWidth: true
            placeholder: "Alarm name"
            onTabPressed: event => root.handleTab(event)
            onEnterPressed: event => root.addAlarm()
        }
        BarButton {
            horizontalPadding: 8
            enabled: alarmTime.acceptableInput
            onClicked: root.addAlarm()
            BarIcon { text: "\uf0f3" }
        }
    }

    ListView {
        id: alarmList
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(contentHeight, 150)
        visible: Timers.alarms.length > 0
        clip: true
        spacing: 2
        boundsBehavior: Flickable.StopAtBounds
        model: Timers.alarms

        delegate: Rectangle {
            id: alarmRow
            required property var modelData
            width: alarmList.width
            height: 46
            radius: 12
            color: alarmHover.hovered ? Theme.hover : "transparent"

            HoverHandler { id: alarmHover }

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 6
                }
                spacing: 6

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    BarText {
                        Layout.fillWidth: true
                        text: alarmRow.modelData.label
                        elide: Text.ElideRight
                    }
                    BarText {
                        text: Qt.formatDateTime(new Date(alarmRow.modelData.deadline * 1000), "ddd HH:mm")
                            + " · " + root.formatDuration(alarmRow.modelData.remaining)
                        color: Theme.fgMuted
                        font.pixelSize: Config.fontSize - 3
                    }
                }
                BarButton {
                    horizontalPadding: 6
                    tint: Theme.red
                    onClicked: Timers.remove(alarmRow.modelData.id)
                    BarIcon { text: "\uf1f8" }
                }
            }
        }
    }

    BarText {
        Layout.fillWidth: true
        visible: Timers.errorMessage !== ""
        text: Timers.errorMessage
        color: Theme.red
        font.pixelSize: Config.fontSize - 2
        wrapMode: Text.Wrap
    }

    BarText {
        Layout.fillWidth: true
        visible: Timers.loaded && Timers.count === 0
        text: "No active timers or alarms"
        color: Theme.fgMuted
        horizontalAlignment: Text.AlignHCenter
    }

    BarText {
        Layout.fillWidth: true
        text: "Timer durations are minutes · alarms use 24-hour time; past times schedule tomorrow"
        color: Theme.fgMuted
        font.pixelSize: Config.fontSize - 3
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
    }
}
