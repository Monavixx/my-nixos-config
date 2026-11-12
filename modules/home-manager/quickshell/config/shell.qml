//@ pragma UseQApplication
import Quickshell
import qs.bar

ShellRoot {
    // One bar per screen. Variants hands each delegate `modelData` (the screen).
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
