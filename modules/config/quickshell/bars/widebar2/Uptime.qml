import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    property var theme: ({})

    implicitWidth: upRow.implicitWidth
    implicitHeight: 32

    FileView {
        id: uptimeFile
        path: "/proc/uptime"
        printErrors: false
    }

    function updateUptime() {
        const secs = Math.floor(Number(uptimeFile.text().trim().split(" ")[0]) || 0)
        const h = String(Math.floor(secs / 3600)).padStart(2, "0")
        const m = String(Math.floor((secs % 3600) / 60)).padStart(2, "0")
        const s = String(secs % 60).padStart(2, "0")
        upText.text = h + ":" + m + ":" + s
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateUptime()
    }

    Component.onCompleted: {
        uptimeFile.reload()
        updateUptime()
    }

    Row {
        id: upRow
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: upText
            anchors.verticalCenter: parent.verticalCenter
            color: theme.fg || "#ffffff"
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font Mono"
            font.weight: Font.Medium
        }
    }
}
