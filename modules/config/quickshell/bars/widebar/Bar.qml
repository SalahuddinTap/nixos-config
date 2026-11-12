import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    readonly property string bg: "#000000"
    readonly property string fg: "#ffffff"
    readonly property string dim: "#333333"

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 0
        left: 0
        right: 0
    }
    implicitHeight: 32
    color: "transparent"
    exclusiveZone: 32

    Rectangle {
        anchors.fill: parent
        color: root.bg
        opacity: 1

        // Center clock
        Clock {
            anchors.centerIn: parent
            theme: ({
                fg: root.fg,
                dim: root.dim,
                bg: root.bg
            })
        }
    }
}