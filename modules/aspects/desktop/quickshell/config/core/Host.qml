pragma Singleton
import Quickshell

// "laptop" or "desktop", handed over from Nix through the QS_HOST_TYPE env var.
Singleton {
    readonly property string type: Quickshell.env("QS_HOST_TYPE") || "desktop"
    readonly property bool isLaptop: type === "laptop"
}
