import QtQuick
import qs.core

// Circular progress ring with a smoothly animated value.
Item {
    id: root

    property real value: 0            // 0..1
    property color tint: Theme.accent
    property int thickness: 6

    property real shown: value
    Behavior on shown { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
    onShownChanged: canvas.requestPaint()
    onTintChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            const cx = width / 2
            const cy = height / 2
            const r = (Math.min(width, height) - root.thickness) / 2
            ctx.lineWidth = root.thickness
            ctx.lineCap = "round"

            ctx.strokeStyle = Theme.alpha(Theme.text, 0.10)
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.stroke()

            ctx.strokeStyle = root.tint
            ctx.beginPath()
            const end = -Math.PI / 2 + Math.PI * 2 * Math.max(0.001, Math.min(1, root.shown))
            ctx.arc(cx, cy, r, -Math.PI / 2, end)
            ctx.stroke()
        }
    }
}
