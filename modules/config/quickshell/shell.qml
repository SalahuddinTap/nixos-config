//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import "bars/anomshell"

ShellRoot {
    id: root

    property string activeBar: "anomshell"

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property var modelData
            width: 1; height: 1

            Loader {
                active: true
                sourceComponent: {
                    if (root.activeBar === "anomshell") return anomshellComp
                    if (root.activeBar === "dynamicglacier") return dynamicGlacierComp
                    return hyprminimalComp
                }
            }
        }
    }

    Component {
        id: anomshellComp
        AnomshellFlat {
            screen: Quickshell.screens[0]
        }
    }

    // Loaded via source string to avoid QML validation of broken Config singleton
    Component {
        id: hyprminimalComp
        Loader { source: "bars/hyprminimal/HyprMinimal.qml" }
    }

    Component {
        id: dynamicGlacierComp
        Loader { source: "modules/dynamicGlacier/DynamicGlacier.qml" }
    }

    Component.onCompleted: {
        try {
            const content = File.read("/tmp/quickshell-active-bar")
            if (content && content.trim()) activeBar = content.trim()
        } catch (e) {}
    }
}