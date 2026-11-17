pragma Singleton
import QtQuick
import Quickshell
import qs.core

// All widgets only use the semantic properties below (fg, accent, glass, ...).
// To add dynamic wallpaper colors later, we only need to replace `c`.
Singleton {
    id: root

    readonly property var palettes: ({
            latte: {
                rosewater: "#dc8a78",
                flamingo: "#dd7878",
                pink: "#ea76cb",
                mauve: "#8839ef",
                red: "#d20f39",
                maroon: "#e64553",
                peach: "#fe640b",
                yellow: "#df8e1d",
                green: "#40a02b",
                teal: "#179299",
                sky: "#04a5e5",
                sapphire: "#209fb5",
                blue: "#1e66f5",
                lavender: "#7287fd",
                text: "#4c4f69",
                subtext1: "#5c5f77",
                subtext0: "#6c6f85",
                overlay2: "#7c7f93",
                overlay1: "#8c8fa1",
                overlay0: "#9ca0b0",
                surface2: "#acb0be",
                surface1: "#bcc0cc",
                surface0: "#ccd0da",
                base: "#eff1f5",
                mantle: "#e6e9ef",
                crust: "#dce0e8"
            },
            frappe: {
                rosewater: "#f2d5cf",
                flamingo: "#eebebe",
                pink: "#f4b8e4",
                mauve: "#ca9ee6",
                red: "#e78284",
                maroon: "#ea999c",
                peach: "#ef9f76",
                yellow: "#e5c890",
                green: "#a6d189",
                teal: "#81c8be",
                sky: "#99d1db",
                sapphire: "#85c1dc",
                blue: "#8caaee",
                lavender: "#babbf1",
                text: "#c6d0f5",
                subtext1: "#b5bfe2",
                subtext0: "#a5adce",
                overlay2: "#949cbb",
                overlay1: "#838ba7",
                overlay0: "#737994",
                surface2: "#626880",
                surface1: "#51576d",
                surface0: "#414559",
                base: "#303446",
                mantle: "#292c3c",
                crust: "#232634"
            },
            macchiato: {
                rosewater: "#f4dbd6",
                flamingo: "#f0c6c6",
                pink: "#f5bde6",
                mauve: "#c6a0f6",
                red: "#ed8796",
                maroon: "#ee99a0",
                peach: "#f5a97f",
                yellow: "#eed49f",
                green: "#a6da95",
                teal: "#8bd5ca",
                sky: "#91d7e3",
                sapphire: "#7dc4e4",
                blue: "#8aadf4",
                lavender: "#b7bdf8",
                text: "#cad3f5",
                subtext1: "#b8c0e0",
                subtext0: "#a5adcb",
                overlay2: "#939ab7",
                overlay1: "#8087a2",
                overlay0: "#6e738d",
                surface2: "#5b6078",
                surface1: "#494d64",
                surface0: "#363a4f",
                base: "#24273a",
                mantle: "#1e2030",
                crust: "#181926"
            },
            mocha: {
                rosewater: "#f5e0dc",
                flamingo: "#f2cdcd",
                pink: "#f5c2e7",
                mauve: "#cba6f7",
                red: "#f38ba8",
                maroon: "#eba0ac",
                peach: "#fab387",
                yellow: "#f9e2af",
                green: "#a6e3a1",
                teal: "#94e2d5",
                sky: "#89dceb",
                sapphire: "#74c7ec",
                blue: "#89b4fa",
                lavender: "#b4befe",
                text: "#cdd6f4",
                subtext1: "#bac2de",
                subtext0: "#a6adc8",
                overlay2: "#9399b2",
                overlay1: "#7f849c",
                overlay0: "#6c7086",
                surface2: "#585b70",
                surface1: "#45475a",
                surface0: "#313244",
                base: "#1e1e2e",
                mantle: "#181825",
                crust: "#11111b"
            }
        })

    // The active palette
    readonly property var c: palettes[Config.flavor] || palettes.mocha

    function alpha(col, a) {
        return Qt.rgba(col.r, col.g, col.b, a);
    }

    // ── base colors ──
    readonly property color base: c.base
    readonly property color mantle: c.mantle
    readonly property color crust: c.crust
    readonly property color surface0: c.surface0
    readonly property color surface1: c.surface1
    readonly property color surface2: c.surface2
    readonly property color text: c.text
    readonly property color subtext0: c.subtext0
    readonly property color overlay0: c.overlay0
    readonly property color overlay1: c.overlay1

    readonly property color red: c.red
    readonly property color peach: c.peach
    readonly property color yellow: c.yellow
    readonly property color green: c.green
    readonly property color teal: c.teal
    readonly property color blue: c.blue
    readonly property color mauve: c.mauve
    readonly property color pink: c.pink
    readonly property color sky: c.sky
    readonly property color lavender: c.lavender
    readonly property color accent: c[Config.accent] || c.mauve

    // ── semantic roles ──
    readonly property color fg: text
    readonly property color fgDim: subtext0
    readonly property color fgMuted: overlay1

    // ── glass ──
    readonly property color glass: alpha(mantle, Config.glassOpacity)
    readonly property color glassBorder: alpha(text, 0.10)
    readonly property color highlightTop: alpha(text, 0.07)
    readonly property color highlightBottom: alpha(text, 0.0)
    readonly property color capsule: alpha(text, 0.05)
    readonly property color capsuleBorder: alpha(text, 0.08)
    readonly property color panel: alpha(base, 0.78)
    readonly property color hover: alpha(text, 0.10)
    readonly property color pressed: alpha(text, 0.16)

    // ── type & motion ──
    readonly property string fontFamily: Config.fontFamily
    readonly property string iconFont: Config.fontFamily
    readonly property int animFast: 120
    readonly property int animNormal: 220
}
