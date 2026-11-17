import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.core
import qs.components
import qs.services

// What each screen shows while locked.
Item {
    id: root

    required property var targetScreen

    readonly property string wallpaper: Wallpaper.outputs[targetScreen.name] || Wallpaper.current
    readonly property string status: LockAuth.error !== "" ? LockAuth.error
        : (LockAuth.fingerprint && LockAuth.fpAvailable
            ? (LockAuth.fpMessage !== "" ? LockAuth.fpMessage : "Touch the sensor or enter your password")
            : "")

    property real appear: 0
    NumberAnimation on appear { from: 0; to: 1; duration: 450; easing.type: Easing.OutCubic }

    opacity: LockAuth.unlocking ? 0 : appear
    Behavior on opacity {
        enabled: LockAuth.unlocking
        NumberAnimation { duration: 200 }
    }

    Component.onCompleted: input.forceActiveFocus()

    SystemClock { id: clock; precision: SystemClock.Minutes }

    // ── background: blurred wallpaper ──
    Image {
        id: wall
        anchors.fill: parent
        visible: false
        source: root.wallpaper ? Wallpaper.toUrl(root.wallpaper) : ""
        sourceSize.width: 1280          // plenty for something that gets blurred
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }
    MultiEffect {
        anchors.fill: parent
        source: wall
        blurEnabled: true
        blur: 1.0
        blurMax: 64
        brightness: -0.1
        saturation: 0.15
        opacity: wall.status === Image.Ready ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }
    Rectangle {
        anchors.fill: parent
        color: Theme.alpha(Theme.base, 0.38)
    }

    // click anywhere to get the keyboard back into the field
    MouseArea {
        anchors.fill: parent
        onClicked: input.forceActiveFocus()
    }

    // ── center ──
    ColumnLayout {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -30
        spacing: 4

        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(clock.date, "HH:mm")
            font.pixelSize: 112
            font.weight: Font.Light
        }
        BarText {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(clock.date, "dddd, d MMMM")
            font.pixelSize: 20
            color: Theme.fgDim
        }

        Item { Layout.preferredHeight: 30 }

        ClippingRectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 92
            Layout.preferredHeight: 92
            radius: 46
            color: Theme.alpha(Theme.text, 0.10)
            border.width: 2
            border.color: Theme.glassBorder

            Image {
                id: face
                anchors.fill: parent
                source: "file://" + Config.avatarPath
                sourceSize.width: 184
                sourceSize.height: 184
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
            BarIcon {
                anchors.centerIn: parent
                visible: face.status !== Image.Ready
                text: "\uf007"
                font.pixelSize: 40
                color: Theme.fgDim
            }
        }

        BarText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 6
            text: Quickshell.env("USER")
            font.pixelSize: 17
            font.bold: true
        }

        Item { Layout.preferredHeight: 14 }

        // ── password field ──
        Rectangle {
            id: pill
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 320
            Layout.preferredHeight: 50
            radius: 25
            color: Theme.alpha(Theme.base, 0.55)
            border.width: 1
            border.color: LockAuth.error !== "" ? Theme.red
                        : input.activeFocus ? Theme.accent : Theme.glassBorder
            Behavior on border.color { ColorAnimation { duration: Theme.animNormal } }

            transform: Translate { id: shake }

            SequentialAnimation {
                id: shakeAnim
                NumberAnimation { target: shake; property: "x"; to: -14; duration: 50 }
                NumberAnimation { target: shake; property: "x"; to: 14; duration: 80 }
                NumberAnimation { target: shake; property: "x"; to: -9; duration: 70 }
                NumberAnimation { target: shake; property: "x"; to: 9; duration: 60 }
                NumberAnimation { target: shake; property: "x"; to: 0; duration: 50 }
            }

            BarIcon {
                anchors { left: parent.left; leftMargin: 18; verticalCenter: parent.verticalCenter }
                text: "\uf023"
                color: Theme.fgMuted
            }

            BarText {
                anchors.centerIn: parent
                visible: input.text.length === 0
                text: LockAuth.busy ? "Checking…" : "Password"
                color: Theme.fgMuted
            }

            Row {
                anchors.centerIn: parent
                spacing: 8
                Repeater {
                    model: Math.min(input.text.length, 24)
                    delegate: Rectangle {
                        width: 10
                        height: 10
                        radius: 5
                        color: Theme.fg
                        NumberAnimation on scale { from: 0; to: 1; duration: 140; easing.type: Easing.OutBack }
                    }
                }
            }

            BarIcon {
                id: spinner
                anchors { right: parent.right; rightMargin: 18; verticalCenter: parent.verticalCenter }
                visible: LockAuth.busy
                text: "\uf110"
                color: Theme.accent
                RotationAnimator on rotation {
                    running: spinner.visible
                    from: 0
                    to: 360
                    duration: 900
                    loops: Animation.Infinite
                }
            }

            // Invisible input that only collects keystrokes; the dots above are the display
            TextInput {
                id: input
                width: 1
                height: 1
                opacity: 0
                focus: true
                echoMode: TextInput.Password
                readOnly: LockAuth.busy || LockAuth.unlocking

                onAccepted: LockAuth.submit(text)
                onTextChanged: if (LockAuth.error !== "") LockAuth.error = ""

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_CapsLock) {
                        LockAuth.capsKey()
                    } else if (event.key === Qt.Key_Escape) {
                        text = ""
                        event.accepted = true
                    }
                }
            }
        }

        BarText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 6
            Layout.preferredHeight: 20
            text: root.status
            color: LockAuth.error !== "" ? Theme.red : Theme.fgMuted
            font.pixelSize: Config.fontSize - 1
        }
    }

    Connections {
        target: LockAuth
        function onFailed() {
            input.text = ""
            shakeAnim.restart()
        }
    }

    // ── bottom left: keyboard layout + caps lock ──
    Capsule {
        anchors { left: parent.left; bottom: parent.bottom; margins: 24 }

        KeyboardWidget {}
        Rectangle {
            visible: LockAuth.capsLock
            implicitWidth: capsLabel.implicitWidth + 20
            implicitHeight: Config.barHeight - 14
            radius: height / 2
            color: Theme.alpha(Theme.peach, 0.22)
            BarText {
                id: capsLabel
                anchors.centerIn: parent
                text: "CAPS"
                color: Theme.peach
                font.bold: true
                font.pixelSize: Config.fontSize - 2
            }
        }
    }

    // ── bottom center: now playing ──
    Item {
        visible: media.player !== null
        width: media.width
        height: media.height
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 24 }

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: Theme.panel
        }
        MediaCard {
            id: media
            width: 380
            active: true
        }
    }

    // ── bottom right: battery (laptop only) ──
    Capsule {
        visible: Host.isLaptop
        anchors { right: parent.right; bottom: parent.bottom; margins: 24 }

        Loader {
            active: Host.isLaptop
            sourceComponent: BatteryWidget {}
        }
    }
}
