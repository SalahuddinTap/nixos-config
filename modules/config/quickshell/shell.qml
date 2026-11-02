//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import "bars/anomshell"

ShellRoot {
    id: root

    property string activeBar: Quickshell.env("QS_ACTIVE_BAR") || "anomshell"

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property var modelData
            width: 1; height: 1

            Loader {
                active: true
                sourceComponent: {
                    if (root.activeBar === "dynamicglacier") return dynamicGlacierComp
                    if (root.activeBar === "hyprminimal") return hyprminimalComp
                    return anomshellComp
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

    Component {
        id: hyprminimalComp
        Loader { source: "bars/hyprminimal/HyprMinimal.qml" }
    }

    Component {
        id: dynamicGlacierComp
        Loader { source: "modules/dynamicGlacier/DynamicGlacier.qml" }
    }
}