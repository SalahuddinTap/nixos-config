//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "bars/hyprminimal"
import "bars/anomshell"

ShellRoot {
    id: root

    property string activeBar: "hyprminimal"

    Loader {
        id: barLoader
        anchors.fill: parent
        sourceComponent: activeBar === "dynamicglacier" ? dynamicGlacierComponent :
                         activeBar === "anomshell" ? anomshellComponent :
                         hyprminimalComponent
    }

    Component {
        id: hyprminimalComponent
        HyprMinimal {}
    }

    Component {
        id: anomshellComponent
        AnomshellFlat {
            hyprMonitor: Hyprland.monitorFor(Screen.primary)
        }
    }

    // DynamicGlacier loaded on-demand to avoid missing Qt5Compat.GraphicalEffects dependency
    Component {
        id: dynamicGlacierComponent
        Loader {
            source: "modules/dynamicGlacier/DynamicGlacier.qml"
        }
    }

    // Allow switching via environment variable or file
    Component.onCompleted: {
        const barFile = "/tmp/quickshell-active-bar"
        if (FileSystem.exists(barFile)) {
            activeBar = FileSystem.readFile(barFile).trim()
        }
    }
}