//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import "bars/widebar"
import "bars/widebar2"
import "osd"
import "notifications"
import "app-launcher"

ShellRoot {
    id: root

    // Active bar: "dynamicglacier" (island), "widebar" or "widebar2" (wide).
    // Switch with: bar-switch.sh island|wide|widebar2
    property string activeBar: Quickshell.env("QS_ACTIVE_BAR") || "dynamicglacier"

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property var modelData
            width: 1; height: 1

            Loader {
                active: true
                sourceComponent: root.activeBar === "widebar"
                    ? widebarComp
                    : root.activeBar === "widebar2"
                        ? widebar2Comp
                        : dynamicGlacierComp
            }
        }
    }

    Component {
        id: widebarComp
        Widebar {
            screen: Quickshell.screens[0]
        }
    }

    Component {
        id: widebar2Comp
        Widebar2 {
            screen: Quickshell.screens[0]
        }
    }

    Component {
        id: dynamicGlacierComp
        Loader { source: "modules/dynamicGlacier/DynamicGlacier.qml" }
    }

    // OSD (volume/brightness overlay)
    OSD { }

    // Notifications
    NotificationPopup { }

    // App Launcher
    AppLauncher { }
}
