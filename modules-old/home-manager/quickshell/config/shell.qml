//@ pragma UseQApplication
import Quickshell
import qs.bar
import qs.modules

ShellRoot {
    // One bar per screen. Variants hands each delegate `modelData` (the screen).
    Variants {
        model: Quickshell.screens
        Bar {}
    }
    Variants {
        model: Quickshell.screens
        NotificationPopups {}
    }
    Lock {}
}
