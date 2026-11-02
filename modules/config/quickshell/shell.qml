//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import "bars/anomshell"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        AnomshellFlat {
            required property var modelData
            screen: modelData
        }
    }
}