import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Scope {
    id: root

    // ─── Theme (inlined Tokyo Night Night) ──────────────────────────────
    readonly property var theme: QtObject {
        readonly property color bgBase:        "#1a1b26"
        readonly property color bgSurface:     "#24283b"
        readonly property color bgOverlay:     "#88000000"
        readonly property color bgHover:       "#1e2235"
        readonly property color bgSelected:    "#283457"
        readonly property color bgBorder:      "#32364a"
        readonly property color textPrimary:   "#c0caf5"
        readonly property color textSecondary: "#a9b1d6"
        readonly property color textMuted:     "#565f89"
        readonly property color accentPrimary: "#7aa2f7"
        readonly property color accentCyan:    "#7dcfff"
        readonly property color accentGreen:   "#9ece6a"
        readonly property color accentOrange:  "#ff9e64"
        readonly property color accentRed:     "#f7768e"
        readonly property color batteryGood:   "#9ece6a"
        readonly property color batteryWarning:"#ff9e64"
        readonly property color batteryCritical:"#f7768e"
    }
    property string font: "JetBrainsMono Nerd Font Mono"
    property bool barVisible: true

    // ─── Time & Date (manual, since Quickshell.Time may not exist) ──────
    property string timeString: ""
    property string dateString: ""
    function updateTime() {
        const now = new Date()
        let h = now.getHours()
        const min = String(now.getMinutes()).padStart(2, "0")
        const ampm = h >= 12 ? "PM" : "AM"
        h = h % 12 || 12
        timeString = String(h).padStart(2, "0") + ":" + min + " " + ampm
        dateString = Qt.formatDate(now, "ddd, d MMM")
    }
    Timer { interval: 1000; running: true; repeat: true; onTriggered: updateTime() }
    Component.onCompleted: updateTime()

    // ─── MPRIS Active Player ────────────────────────────────────────────
    property var activePlayer: {
        const players = Mpris.players.values;
        if (!players || players.length === 0) return null;
        for (const p of players) {
            if (p.playbackState === MprisPlaybackState.Playing) return p;
        }
        return players[0];
    }

    // ─── Brightness ─────────────────────────────────────────────────────
    property real brightnessValue: 0
    property real brightnessMax: 1

    FileView {
        id: brightnessFile
        path: ""
        watchChanges: true
        onFileChanged: brightnessReadProc.running = true
    }
    Process {
        id: brightnessReadProc
        command: ["brightnessctl", "get"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(text.trim());
                if (!isNaN(val) && root.brightnessMax > 0)
                    root.brightnessValue = val / root.brightnessMax;
            }
        }
    }
    Process { id: brightnessSetProc; running: false }
    Process {
        id: backlightDiscovery
        command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo \"$p\" && cat \"${p%brightness}max_brightness\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length >= 2) {
                    const max = parseInt(lines[1]);
                    if (!isNaN(max) && max > 0) root.brightnessMax = max;
                    brightnessFile.path = lines[0];
                    brightnessReadProc.running = true;
                }
            }
        }
    }

    // ─── System Stats (CPU, RAM, Battery, Network, Temp) ───────────────
    property string cpuUsage: "–"
    property string memUsage: "–"
    property real cpuVal: 0
    property real ramVal: 0

    // CPU/RAM
    function refreshStats() { statsProc.running = false; statsProc.running = true }
    Process {
        id: statsProc
        command: ["bash", "-c", "printf '%s\\n' \"$(cat /proc/stat | head -1)\"; free | awk '/^Mem/{printf \"%d\\n\",$3/$2*100}'"]
        property var last: null
        running: true
        stdout: SplitParser {
            property int line: 0
            onRead: data => {
                const t = data.trim()
                if (!t) return
                if (line === 0) {
                    const p = t.split(/\s+/).slice(1).map(Number)
                    if (statsProc.last) {
                        const idle = p[3] - statsProc.last[3]
                        const total = p.reduce((a,b)=>a+b,0) - statsProc.last.reduce((a,b)=>a+b,0)
                        if (total > 0) {
                            cpuVal = Math.round((1 - idle/total) * 100)
                            cpuUsage = cpuVal + "%"
                        }
                    }
                    statsProc.last = p
                } else {
                    ramVal = parseInt(t) || 0
                    memUsage = Math.round(ramVal) + "%"
                }
                line++
            }
        }
        onExited: statsProc.stdout.line = 0
    }
    Timer { interval: 3000; running: true; repeat: true; onTriggered: refreshStats() }

    // Battery (via UPower)
    property bool batteryCharging: false
    property int batteryLevelRaw: 100
    property string batteryLevel: "100%"
    property string batteryIcon: "󰁹"
    function updateBattery() {
        const dev = UPower.displayDevice
        if (dev && dev.ready) {
            batteryLevelRaw = Math.round(dev.percentage)
            batteryLevel = batteryLevelRaw + "%"
            batteryCharging = dev.state === UPowerDeviceState.Charging
            const p = dev.percentage
            if (p >= 90) batteryIcon = "󰁹"
            else if (p >= 80) batteryIcon = "󰂂"
            else if (p >= 70) batteryIcon = "󰂁"
            else if (p >= 60) batteryIcon = "󰂀"
            else if (p >= 50) batteryIcon = "󰁿"
            else if (p >= 40) batteryIcon = "󰁾"
            else if (p >= 30) batteryIcon = "󰁽"
            else if (p >= 20) batteryIcon = "󰁼"
            else if (p >= 10) batteryIcon = "󰁻"
            else batteryIcon = "󰁺"
        }
    }
    Component.onCompleted: updateBattery()
    Connections {
        target: UPower.displayDevice
        function onPercentageChanged() { updateBattery() }
        function onStateChanged() { updateBattery() }
        function onReadyChanged() { if (UPower.displayDevice.ready) updateBattery() }
    }

    // Network (basic type detection via nmcli)
    property string networkType: "disconnected"
    property string networkInfo: "–"
    function refreshNetwork() { netProc.running = false; netProc.running = true }
    Process {
        id: netProc
        command: ["bash", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device 2>/dev/null | grep -E '^(wifi|ethernet):connected' | head -1 | cut -d: -f1-3"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const out = text.trim()
                if (!out) { networkType = "disconnected"; networkInfo = "–"; return }
                const parts = out.split(":")
                networkType = parts[0]
                networkInfo = parts[2] || "connected"
            }
        }
    }
    Timer { interval: 10000; running: true; repeat: true; onTriggered: refreshNetwork() }

    // Temperature (simple)
    property string temperature: "–"
    function refreshTemp() { tempProc.running = false; tempProc.running = true }
    Process {
        id: tempProc
        command: ["bash", "-c", "sensors 2>/dev/null | grep -E 'Package|Core|Tctl|CPU' | head -1 | awk '{print $2}' | tr -d '+°C'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: { temperature = text.trim() || "–" }
        }
    }
    Timer { interval: 5000; running: true; repeat: true; onTriggered: refreshTemp() }

    // ─── IPC Toggle ─────────────────────────────────────────────────────
    IpcHandler { target: "bar-w"; function toggle(): void { root.barVisible = !root.barVisible; } }

    // ─── Pipewire Tracker ───────────────────────────────────────────────
    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    // ─── Per-Screen Bar ─────────────────────────────────────────────────
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: root.barVisible

            anchors { top: true; left: true; right: true }
            implicitHeight: 32
            color: root.theme.bgBase

            Item {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                // ─── Left Section ────────────────────────────────────────
                Row {
                    id: leftSection
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    // Time
                    Rectangle {
                        height: 24
                        width: timeDate.width + 16
                        radius: 12
                        color: root.theme.bgSurface

                        Row {
                            id: timeDate
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "󰃭"
                                color: root.theme.accentPrimary
                                font.pixelSize: 14
                                font.family: root.font
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.timeString
                                color: root.theme.textPrimary
                                font.pixelSize: 12
                                font.family: root.font
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.dateString
                                color: root.theme.textSecondary
                                font.pixelSize: 12
                                font.family: root.font
                            }
                        }
                    }

                    // Workspaces
                    Row { spacing: 4
                        Repeater {
                            model: Hyprland.workspaces
                            Rectangle {
                                id: wsPill
                                required property var modelData
                                property bool urgentBlink: false
                                width: modelData.focused ? 32 : 24
                                height: 24
                                radius: 12
                                color: modelData.focused ? root.theme.accentPrimary :
                                       modelData.urgent && urgentBlink ? root.theme.accentRed : root.theme.bgSurface
                                Behavior on color { ColorAnimation { duration: 150 } }
                                SequentialAnimation {
                                    loops: Animation.Infinite
                                    running: wsPill.modelData.urgent && !wsPill.modelData.focused
                                    PropertyAction { target: wsPill; property: "urgentBlink"; value: true }
                                    PauseAnimation { duration: 500 }
                                    PropertyAction { target: wsPill; property: "urgentBlink"; value: false }
                                    PauseAnimation { duration: 500 }
                                    onStopped: wsPill.urgentBlink = false
                                }
                                Text {
                                    anchors.centerIn: parent
                                    text: wsPill.modelData.id
                                    color: wsPill.modelData.focused ? root.theme.bgBase : root.theme.textPrimary
                                    font.pixelSize: 11
                                    font.family: root.font
                                    font.bold: wsPill.modelData.focused
                                }
                                MouseArea { anchors.fill: parent; onClicked: wsPill.modelData.activate() }
                                Behavior on width { NumberAnimation { duration: 150 } }
                            }
                        }
                    }

                    // Now Playing
                    Rectangle {
                        height: 24
                        width: nowPlayingContent.width + 16
                        radius: 12
                        color: root.theme.bgSurface
                        visible: root.activePlayer !== null

                        Row {
                            id: nowPlayingContent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            spacing: 6

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.activePlayer && root.activePlayer.isPlaying ? "󰐊" : "󰏤"
                                color: root.theme.accentPrimary
                                font.pixelSize: 14
                                font.family: root.font
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: {
                                    if (!root.activePlayer) return "";
                                    const artist = root.activePlayer.trackArtist || "";
                                    const title = root.activePlayer.trackTitle || "";
                                    return artist ? artist + " - " + title : title;
                                }
                                color: root.theme.textPrimary
                                font.pixelSize: 11
                                font.family: root.font
                                elide: Text.ElideRight
                                width: Math.min(implicitWidth, 200)
                            }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.activePlayer.togglePlaying() }
                    }
                }

                // ─── Center: Window Title ───────────────────────────────
                Item {
                    anchors.centerIn: parent
                    height: parent.height
                    width: Math.max(0, parent.width - 2 * Math.max(leftSection.width, rightSection.width) - 32)
                    Text {
                        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
                        color: root.theme.textPrimary
                        font.pixelSize: 13
                        font.family: root.font
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, parent.width)
                        anchors.centerIn: parent
                    }
                }

                // ─── Right Section ──────────────────────────────────────
                Row {
                    id: rightSection
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    // Volume
                    Rectangle {
                        height: 24
                        width: volContent.width + 12
                        radius: 12
                        color: root.theme.bgSurface
                        Row {
                            id: volContent
                            anchors.centerIn: parent
                            spacing: 6
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: {
                                    const sink = Pipewire.defaultAudioSink;
                                    if (!sink || !sink.audio || sink.audio.muted || sink.audio.volume <= 0) return "󰖁";
                                    if (sink.audio.volume < 0.33) return "󰕿";
                                    if (sink.audio.volume < 0.66) return "󰖀";
                                    return "󰕾";
                                }
                                color: { const sink = Pipewire.defaultAudioSink; if (!sink || !sink.audio || sink.audio.muted) return root.theme.textMuted; return root.theme.accentPrimary; }
                                font.pixelSize: 14; font.family: root.font
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: { const sink = Pipewire.defaultAudioSink; if (!sink || !sink.audio) return "–"; if (sink.audio.muted) return "Mute"; return Math.round(sink.audio.volume * 100) + "%"; }
                                color: root.theme.textPrimary; font.pixelSize: 11; font.family: root.font
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor; acceptedButtons: Qt.LeftButton
                            onClicked: { const sink = Pipewire.defaultAudioSink; if (sink && sink.audio) sink.audio.muted = !sink.audio.muted; }
                            onWheel: (wheel) => { const sink = Pipewire.defaultAudioSink; if (!sink || !sink.audio) return; const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05; sink.audio.volume = Math.max(0, Math.min(1.5, sink.audio.volume + delta)); }
                        }
                    }

                    // Brightness
                    Rectangle {
                        height: 24; width: brightContent.width + 12; radius: 12; color: root.theme.bgSurface
                        visible: brightnessFile.path !== ""
                        Row { id: brightContent; anchors.centerIn: parent; spacing: 6
                            Text { anchors.verticalCenter: parent.verticalCenter; text: "󰃠"; color: root.theme.accentOrange; font.pixelSize: 14; font.family: root.font }
                            Text { anchors.verticalCenter: parent.verticalCenter; text: Math.round(root.brightnessValue * 100) + "%"; color: root.theme.textPrimary; font.pixelSize: 11; font.family: root.font }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onWheel: (wheel) => { brightnessSetProc.command = wheel.angleDelta.y > 0 ? ["brightnessctl", "set", "5%+"] : ["brightnessctl", "set", "5%-"]; brightnessSetProc.running = true; } }
                    }

                    // System Info Row
                    Row { id: sysInfo; spacing: 4
                        readonly property color batteryColor: root.batteryCharging ? root.theme.accentGreen : root.batteryLevelRaw > 20 ? root.theme.batteryGood : root.batteryLevelRaw > 10 ? root.theme.batteryWarning : root.theme.batteryCritical

                        // CPU
                        Rectangle { height: 24; width: cpuContent.width + 12; radius: 12; color: root.theme.bgSurface
                            Row { id: cpuContent; anchors.centerIn: parent; spacing: 6
                                Text { anchors.verticalCenter: parent.verticalCenter; text: "󰻠"; color: root.theme.accentOrange; font.pixelSize: 14; font.family: root.font }
                                Text { anchors.verticalCenter: parent.verticalCenter; text: root.cpuUsage; color: root.theme.textPrimary; font.pixelSize: 11; font.family: root.font }
                            }
                        }
                        // Network
                        Rectangle { height: 24; width: netContent.width + 12; radius: 12; color: root.theme.bgSurface
                            Row { id: netContent; anchors.centerIn: parent; spacing: 6
                                Text { anchors.verticalCenter: parent.verticalCenter; text: root.networkType === "ethernet" ? "󰈀" : root.networkType === "wifi" ? "󰖩" : "󰖪"; color: root.networkType === "disconnected" ? root.theme.textMuted : root.theme.accentGreen; font.pixelSize: 14; font.family: root.font }
                                Text { anchors.verticalCenter: parent.verticalCenter; text: root.networkInfo; color: root.theme.textPrimary; font.pixelSize: 11; font.family: root.font }
                            }
                        }
                        // Battery
                        Rectangle { height: 24; width: battContent.width + 12; radius: 12; color: root.theme.bgSurface
                            Row { id: battContent; anchors.centerIn: parent; spacing: 6
                                Text { anchors.verticalCenter: parent.verticalCenter; text: root.batteryIcon; color: sysInfo.batteryColor; font.pixelSize: 14; font.family: root.font }
                                Text { anchors.verticalCenter: parent.verticalCenter; text: root.batteryLevel; color: root.theme.textPrimary; font.pixelSize: 11; font.family: root.font }
                            }
                        }
                        // Temperature
                        Rectangle { height: 24; width: tempContent.width + 12; radius: 12; color: root.theme.bgSurface
                            Row { id: tempContent; anchors.centerIn: parent; spacing: 6
                                Text { anchors.verticalCenter: parent.verticalCenter; text: "󰔏"; color: root.theme.accentRed; font.pixelSize: 14; font.family: root.font }
                                Text { anchors.verticalCenter: parent.verticalCenter; text: root.temperature + "°C"; color: root.theme.textPrimary; font.pixelSize: 11; font.family: root.font }
                            }
                        }
                    }

                    // System Tray
                    Rectangle {
                        implicitHeight: 24; implicitWidth: trayIcons.implicitWidth + 4; radius: 12; color: root.theme.bgSurface
                        RowLayout { id: trayIcons; anchors.centerIn: parent; spacing: 2
                            Repeater { model: SystemTray.items
                                MouseArea {
                                    id: trayDelegate; required property SystemTrayItem modelData
                                    Layout.preferredWidth: 24; Layout.preferredHeight: 24
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                    onClicked: (mouse) => { if (mouse.button === Qt.LeftButton) modelData.activate(); else if (mouse.button === Qt.RightButton && modelData.hasMenu) menuAnchor.open(); else if (mouse.button === Qt.MiddleButton) modelData.secondaryActivate(); }
                                    Image { anchors.centerIn: parent; source: trayDelegate.modelData.icon; width: 16; height: 16; fillMode: Image.PreserveAspectFit }
                                    QsMenuAnchor { id: menuAnchor; menu: trayDelegate.modelData.menu; anchor.window: trayDelegate.QsWindow.window; anchor.adjustment: PopupAdjustment.Flip; anchor.onAnchoring: { const window = trayDelegate.QsWindow.window; const widgetRect = window.contentItem.mapFromItem(trayDelegate, 0, trayDelegate.height, trayDelegate.width, trayDelegate.height); menuAnchor.anchor.rect = widgetRect; } }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}