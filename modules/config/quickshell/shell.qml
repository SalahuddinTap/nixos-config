//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import "bars/anomshell"
import "bars/bar-me"
import "bars/bar-mines"
import "bars/bar-w"
import "osd"
import "notifications"
import "app-launcher"

ShellRoot {
    id: root

    property string activeBar: Quickshell.env("QS_ACTIVE_BAR") || "bar-w"

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property var modelData
            width: 1; height: 1

            Loader {
                active: true
                sourceComponent: {
                    if (root.activeBar === "bar-w") return barWComp
                    if (root.activeBar === "dynamicglacier") return dynamicGlacierComp
                    if (root.activeBar === "hyprminimal") return hyprminimalComp
                    if (root.activeBar === "bar-me") return barMeComp
                    if (root.activeBar === "bar-mines") return barMinesComp
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

    Component {
        id: barMeComp
        Loader { source: "bars/bar-me/BarMe.qml" }
    }

    Component {
        id: barMinesComp
        Loader { source: "bars/bar-mines/BarMines.qml" }
    }

    Component {
        id: barWComp
        BarW { }
    }

    // OSD (volume/brightness overlay)
    OSD { }

    // Notifications
    NotificationPopup { }

    // App Launcher
    AppLauncher { }
}