import QtQuick
import Quickshell
import Quickshell.Wayland

Item {
    id: root
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    property var theme: ({})

    implicitWidth: clockRow.implicitWidth
    implicitHeight: 32

    function updateTime() {
        const now = new Date()
        const day = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][now.getDay()]
        const h = String(now.getHours()).padStart(2, "0")
        const m = String(now.getMinutes()).padStart(2, "0")
        const s = String(now.getSeconds()).padStart(2, "0")
        timeText.text = day + "  " + h + ":" + m + ":" + s
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    Component.onCompleted: updateTime()

    // ── Clock row ─────────────────────────────────
    Row {
        id: clockRow
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: timeText
            anchors.verticalCenter: parent.verticalCenter
            color: theme.fg || "#ffffff"
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font Mono"
            font.weight: Font.Medium
        }
    }
}