//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    id: root

    property string activeBar: "hyprminimal"

    Variants {
        model: Quickshell.screens

        Loader {
            id: barLoader
            required property var modelData
            source: root.activeBar === "anomshell" ? "bars/anomshell/AnomshellFlat.qml" :
                    root.activeBar === "dynamicglacier" ? "modules/dynamicGlacier/DynamicGlacier.qml" :
                    "bars/hyprminimal/HyprMinimal.qml"
        }
    }

    Component.onCompleted: {
        // Read active bar from file
        const barFile = "/tmp/quickshell-active-bar"
        try {
            const content = File.read(barFile)
            if (content && content.trim()) {
                activeBar = content.trim()
            }
        } catch (e) {
            // File doesn't exist, use default
        }
    }
}