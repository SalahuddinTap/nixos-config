//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Hyprland

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

    // All components lazy-loaded via Loader to avoid validation of unused components
    Component {
        id: hyprminimalComponent
        Loader {
            source: "bars/hyprminimal/HyprMinimal.qml"
        }
    }

    Component {
        id: anomshellComponent
        Loader {
            source: "bars/anomshell/AnomshellFlat.qml"
            property var hyprMonitor: Hyprland.monitorFor(Screen.primary)
        }
    }

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