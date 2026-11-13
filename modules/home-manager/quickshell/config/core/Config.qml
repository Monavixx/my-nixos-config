pragma Singleton
import Quickshell

// Everything you're likely to tweak lives here.
Singleton {
    // Catppuccin: "latte" | "frappe" | "macchiato" | "mocha"
    readonly property string flavor: "mocha"
    // Any palette key: mauve, blue, lavender, pink, peach, teal, sky, ...
    readonly property string accent: "flamingo"

    readonly property string fontFamily: "FantasqueSansM Nerd Font"
    readonly property int fontSize: 13

    readonly property int barHeight: 40
    readonly property int workspaceCount: 5
    readonly property real glassOpacity: 0.55

    // Commands
    readonly property var terminal: ["kitty", "-e"]   // used as: terminal + command
    readonly property var audioMixer: ["pavucontrol"]
    readonly property var networkTui: ["nmtui"]
    readonly property var powerMenu: ["wlogout"]

    readonly property string cpuTempPath: "/sys/class/thermal/thermal_zone0/temp"
    readonly property string diskPath: "/"
}
