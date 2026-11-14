import QtQuick
import QtQuick.Layouts
import qs.core
import qs.components
import qs.services

SubPage {
    id: root

    name: "tasks"
    title: "Tasks" + (Tasks.count > 0 ? "  ·  " + Tasks.count : "")

    property real savedY: 0
    // Selection is tracked by uuid, so it follows the task when the list re-sorts
    property string selectedUuid: ""

    function selectedIndex() {
        const arr = Tasks.tasks;
        for (let i = 0; i < arr.length; i++)
            if (arr[i].uuid === selectedUuid)
                return i;
        return -1;
    }

    function move(delta) {
        const arr = Tasks.tasks;
        if (arr.length === 0)
            return;
        const cur = selectedIndex();
        const next = cur < 0 ? 0 : Math.max(0, Math.min(arr.length - 1, cur + delta));
        selectedUuid = arr[next].uuid;
        list.positionViewAtIndex(next, ListView.Contain);
    }

    // Run an action on the selected task, then select its neighbor
    function finish(action) {
        const cur = selectedIndex();
        if (cur < 0)
            return;
        action(Tasks.tasks[cur].uuid);
        const arr = Tasks.tasks;    // already updated, the removal is optimistic
        selectedUuid = arr.length > 0 ? arr[Math.min(cur, arr.length - 1)].uuid : "";
    }

    function handleKey(event, typing) {
        if (event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier))
            return;
        // While typing, Space/Delete/Enter belong to the text field, unless it's empty
        const free = !typing || input.text.length === 0;
        const cur = selectedIndex();

        if (event.key === Qt.Key_Down) {
            move(1);
            event.accepted = true;
        } else if (event.key === Qt.Key_Up) {
            move(-1);
            event.accepted = true;
        } else if (cur >= 0 && free) {
            switch (event.key) {
            case Qt.Key_Return:
            case Qt.Key_Enter:
                finish(u => Tasks.done(u));
                event.accepted = true;
                break;
            case Qt.Key_Delete:
                finish(u => Tasks.remove(u));
                event.accepted = true;
                break;
            case Qt.Key_Space:
                Tasks.toggleStart(Tasks.tasks[cur]);
                event.accepted = true;
                break;
            }
        }
    }

    onKeyPressed: event => handleKey(event, false)

    onShownChanged: if (shown) {
        selectedUuid = "";
        Tasks.refresh();
        focusTimer.restart();
    }

    // Wait for the slide-in to start, so the input is visible when it takes focus
    Timer {
        id: focusTimer
        interval: 150
        onTriggered: input.forceActiveFocus()
    }

    // Replacing the model resets the list; put the scroll position back
    Connections {
        target: Tasks
        function onTasksAboutToChange() {
            root.savedY = list.contentY;
        }
        function onTasksChanged() {
            Qt.callLater(() => {
                list.contentY = Math.min(root.savedY, Math.max(0, list.contentHeight - list.height));
                const i = root.selectedIndex();
                if (i >= 0)
                    list.positionViewAtIndex(i, ListView.Contain);
            });
        }
    }

    component ActionDot: Rectangle {
        id: dot
        property string glyph
        property color tint: Theme.accent
        signal clicked

        implicitWidth: 24
        implicitHeight: 24
        radius: 12
        color: dotMa.containsMouse ? Theme.alpha(tint, 0.2) : "transparent"
        Behavior on color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }

        BarIcon {
            anchors.centerIn: parent
            text: dot.glyph
            font.pixelSize: Config.fontSize - 2
            color: dotMa.containsMouse ? dot.tint : Theme.fgDim
        }
        MouseArea {
            id: dotMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: dot.clicked()
        }
    }

    // ── add field ──
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 38
        radius: 19
        color: Theme.capsule
        border.width: 1
        border.color: input.activeFocus ? Theme.accent : Theme.capsuleBorder
        Behavior on border.color {
            ColorAnimation {
                duration: Theme.animFast
            }
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 14
                rightMargin: 14
            }
            spacing: 8

            BarIcon {
                text: "\uf067"
                color: Theme.fgMuted
                font.pixelSize: Config.fontSize - 1
            }
            TextInput {
                id: input
                Layout.fillWidth: true
                clip: true
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Config.fontSize
                selectionColor: Theme.accent
                selectedTextColor: Theme.crust
                verticalAlignment: TextInput.AlignVCenter
                Keys.onPressed: event => root.handleKey(event, true)
                onAccepted: {
                    Tasks.add(text);
                    text = "";
                    root.selectedUuid = "";
                }

                BarText {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    visible: input.text.length === 0
                    text: "Add task…  project:x +tag due:fri"
                    color: Theme.fgMuted
                    font.pixelSize: Config.fontSize - 2
                    elide: Text.ElideRight
                }
            }
        }
    }

    // ── task list ──
    ListView {
        id: list
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(contentHeight, 252)
        visible: Tasks.count > 0
        clip: true
        spacing: 2
        boundsBehavior: Flickable.StopAtBounds
        model: Tasks.tasks

        delegate: Rectangle {
            id: row
            required property var modelData
            readonly property var due: Tasks.dueInfo(modelData.due)
            readonly property string meta: Tasks.meta(modelData)
            readonly property bool started: modelData.start !== undefined
            readonly property bool selected: modelData.uuid === root.selectedUuid
            color: row.selected ? Theme.pressed : rowHover.hovered ? Theme.hover : "transparent"

            width: list.width
            height: 46
            radius: 12
            Behavior on color {
                ColorAnimation {
                    duration: Theme.animFast
                }
            }

            HoverHandler {
                id: rowHover
            }

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                }
                spacing: 10

                // complete button; ring color = priority
                Rectangle {
                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignVCenter
                    radius: 11
                    color: checkMa.containsMouse ? Theme.alpha(Theme.green, 0.22) : "transparent"
                    border.width: 2
                    border.color: checkMa.containsMouse ? Theme.green : Tasks.priorityColor(row.modelData.priority)
                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animFast
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: Theme.animFast
                        }
                    }

                    BarIcon {
                        anchors.centerIn: parent
                        visible: checkMa.containsMouse
                        text: "\uf00c"
                        color: Theme.green
                        font.pixelSize: 11
                    }
                    MouseArea {
                        id: checkMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Tasks.done(row.modelData.uuid)
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        BarIcon {
                            visible: row.started
                            text: "\uf04b"
                            color: Theme.accent
                            font.pixelSize: Config.fontSize - 4
                        }
                        BarText {
                            Layout.fillWidth: true
                            text: row.modelData.description
                            color: row.started ? Theme.accent : Theme.fg
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        visible: row.meta !== "" || row.due.text !== ""
                        spacing: 8

                        BarText {
                            Layout.fillWidth: true
                            visible: row.meta !== ""
                            text: row.meta
                            color: Theme.fgMuted
                            font.pixelSize: Config.fontSize - 3
                            elide: Text.ElideRight
                        }
                        BarText {
                            visible: row.due.text !== ""
                            text: row.due.text
                            color: row.due.level === 2 ? Theme.red : row.due.level === 1 ? Theme.peach : Theme.fgDim
                            font.pixelSize: Config.fontSize - 3
                        }
                    }
                }

                // hover actions: the space opens up smoothly, so long titles re-elide
                Item {
                    Layout.preferredWidth: rowHover.hovered ? 52 : 0
                    Layout.preferredHeight: 24
                    Layout.alignment: Qt.AlignVCenter
                    clip: true
                    Behavior on Layout.preferredWidth {
                        NumberAnimation {
                            duration: 160
                            easing.type: Easing.OutCubic
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        spacing: 4
                        ActionDot {
                            glyph: row.started ? "\uf04d" : "\uf04b"
                            tint: Theme.accent
                            onClicked: Tasks.toggleStart(row.modelData)
                        }
                        ActionDot {
                            glyph: "\uf1f8"
                            tint: Theme.red
                            onClicked: Tasks.remove(row.modelData.uuid)
                        }
                    }
                }
            }
        }
    }
    BarText {
        Layout.fillWidth: true
        visible: Tasks.count > 0
        text: "↑↓ select  ·  Enter done  ·  Del remove  ·  Space start"
        horizontalAlignment: Text.AlignHCenter
        color: Theme.fgMuted
        font.pixelSize: Config.fontSize - 3
        elide: Text.ElideRight
    }

    // ── empty state ──
    ColumnLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 84
        visible: Tasks.count === 0 && !Tasks.loading
        spacing: 6

        Item {
            Layout.fillHeight: true
        }
        BarIcon {
            Layout.alignment: Qt.AlignHCenter
            text: "\uf058"
            color: Theme.green
            font.pixelSize: Config.fontSize + 12
        }
        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: "All clear"
            color: Theme.fgDim
        }
        Item {
            Layout.fillHeight: true
        }
    }
}
