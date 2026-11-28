import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.core
import qs.components
import qs.services

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    readonly property bool focusedScreen: Hyprland.focusedMonitor === Hyprland.monitorFor(modelData)
    property int selectedIndex: AppLauncher.results.length > 0 ? 0 : -1

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    visible: Shortcuts.launcherOpen && focusedScreen

    WlrLayershell.namespace: "qs-launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    onVisibleChanged: if (visible) {
        root.normalizingInput = true;
        searchInput.text = "";
        AppLauncher.prefix = "";
        AppLauncher.query = "";
        root.normalizingInput = false;
        AppLauncher.refresh();
        selectedIndex = AppLauncher.results.length > 0 ? 0 : -1;
        Qt.callLater(() => searchInput.forceActiveFocus());
    }

    property bool normalizingInput: false

    Connections {
        target: AppLauncher
        function onResultsChanged() {
            root.selectedIndex = AppLauncher.results.length > 0 ? 0 : -1;
        }
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: Theme.alpha(Theme.base, 0.62)
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Shortcuts.closeLauncher()
        }

        Rectangle {
            anchors.centerIn: parent
            width: Math.min(parent.width - 48, 680)
            height: Math.min(parent.height - 64, 560)
            radius: 22
            color: Theme.panel
            border.width: 1
            border.color: Theme.glassBorder

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: Theme.highlightTop
                    }
                    GradientStop {
                        position: 0.5
                        color: Theme.highlightBottom
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        visible: AppLauncher.prefix !== ""
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        radius: 11
                        color: Theme.alpha(Theme.accent, 0.2)
                        border.width: 1
                        border.color: Theme.alpha(Theme.accent, 0.45)

                        BarText {
                            anchors.centerIn: parent
                            text: AppLauncher.prefix
                            color: Theme.accent
                            font.bold: true
                        }
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Config.fontSize + 8
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        clip: true
                        focus: true
                        onTextChanged: {
                            if (root.normalizingInput)
                                return;
                            const normalized = AppLauncher.setInput(text);
                            if (normalized !== text) {
                                root.normalizingInput = true;
                                text = normalized;
                                root.normalizingInput = false;
                            }
                            root.selectedIndex = AppLauncher.results.length > 0 ? 0 : -1;
                        }
                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Down && AppLauncher.results.length > 0) {
                                root.selectedIndex = (root.selectedIndex + 1) % AppLauncher.results.length;
                            } else if (event.key === Qt.Key_Up && AppLauncher.results.length > 0) {
                                root.selectedIndex = (root.selectedIndex - 1 + AppLauncher.results.length) % AppLauncher.results.length;
                            } else if (event.key === Qt.Key_Backspace && text === "" && AppLauncher.prefix !== "") {
                                AppLauncher.prefix = "";
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                AppLauncher.activate(AppLauncher.results[root.selectedIndex]);
                            } else if (event.key === Qt.Key_Escape) {
                                Shortcuts.closeLauncher();
                            } else {
                                return;
                            }
                            event.accepted = true;
                        }

                        BarText {
                            anchors.fill: parent
                            visible: searchInput.text === ""
                            text: AppLauncher.mode
                            color: Theme.fgMuted
                            font.pixelSize: Config.fontSize + 8
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Theme.glassBorder
                }

                ListView {
                    id: resultList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 4
                    model: AppLauncher.results
                    currentIndex: root.selectedIndex
                    onCurrentIndexChanged: if (currentIndex >= 0)
                        positionViewAtIndex(currentIndex, ListView.Contain)

                    delegate: Rectangle {
                        id: row
                        required property int index
                        required property var modelData

                        width: resultList.width
                        height: 48
                        radius: 12
                        color: resultList.currentIndex === index ? Theme.alpha(Theme.accent, 0.16) : "transparent"
                        border.width: resultList.currentIndex === index ? 1 : 0
                        border.color: Theme.alpha(Theme.accent, 0.35)

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            Item {
                                Layout.preferredWidth: 28
                                Layout.preferredHeight: 28

                                Image {
                                    id: appIcon
                                    anchors.fill: parent
                                    visible: source !== ""
                                    source: {
                                        const icon = row.modelData.icon || "";
                                        if (!icon)
                                            return "";
                                        if (icon.startsWith("/") || icon.startsWith("file:") || icon.startsWith("image:"))
                                            return icon.startsWith("/") ? "file://" + icon : icon;
                                        return Quickshell.iconPath(icon, true);
                                    }
                                    sourceSize.width: 56
                                    sourceSize.height: 56
                                    asynchronous: true
                                }
                                BarIcon {
                                    anchors.centerIn: parent
                                    visible: !appIcon.visible || appIcon.status !== Image.Ready
                                    text: row.modelData.kind === "website" ? "\uf0ac" : row.modelData.kind === "calc" ? "\uf1ec" : row.modelData.kind === "command" ? "\uf120" : row.modelData.kind === "web" ? "\uf002" : "\uf0f6"
                                    color: Theme.accent
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                BarText {
                                    Layout.fillWidth: true
                                    text: row.modelData.name
                                    font.bold: resultList.currentIndex === row.index
                                    elide: Text.ElideRight
                                }
                                BarText {
                                    Layout.fillWidth: true
                                    visible: text !== ""
                                    text: row.modelData.detail || ""
                                    color: Theme.fgMuted
                                    font.pixelSize: Config.fontSize - 2
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.selectedIndex = row.index
                            onClicked: AppLauncher.activate(row.modelData)
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    BarText {
                        Layout.fillWidth: true
                        text: "↑/↓ select    Enter launch    Esc close"
                        color: Theme.fgMuted
                        font.pixelSize: Config.fontSize - 2
                    }
                    BarText {
                        text: AppLauncher.prefix ? AppLauncher.mode : "?: web   =: calc   !: run"
                        color: Theme.fgMuted
                        font.pixelSize: Config.fontSize - 2
                    }
                }
            }
        }
    }
}
