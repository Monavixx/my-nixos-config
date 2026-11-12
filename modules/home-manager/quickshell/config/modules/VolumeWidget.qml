import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.core
import qs.components

BarButton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false

    PwObjectTracker {
        objects: [root.sink]
    }

    BarIcon {
        text: root.muted || root.volume < 0.01 ? "\uf026" : root.volume < 0.5 ? "\uf027" : "\uf028"
        color: root.muted ? Theme.fgMuted : Theme.fg
    }
    BarText {
        text: Math.round(root.volume * 100) + "%"
        color: root.muted ? Theme.fgMuted : Theme.fg
    }

    onClicked: m => {
        if (m.button === Qt.LeftButton)
            Quickshell.execDetached(Config.audioMixer);
        else if (root.sink && root.sink.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }
    onScrolled: w => {
        if (!root.sink || !root.sink.audio)
            return;
        const step = w.angleDelta.y < 0 ? 0.01 : -0.01;
        root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + step));
    }
}
