//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import "modules/dynamicGlacier"
import "bars/hyprminimal"

ShellRoot {
    id: root

    property string activeBar: "hyprminimal"

    Loader {
        id: barLoader
        anchors.fill: parent
        sourceComponent: activeBar === "dynamicglacier" ? dynamicGlacierComponent : hyprminimalComponent
    }

    Component {
        id: dynamicGlacierComponent
        DynamicGlacier {}
    }

    Component {
        id: hyprminimalComponent
        HyprMinimal {}
    }

    // Allow switching via environment variable or file
    Component.onCompleted: {
        const barFile = "/tmp/quickshell-active-bar"
        if (FileSystem.exists(barFile)) {
            activeBar = FileSystem.readFile(barFile).trim()
        }
    }
}