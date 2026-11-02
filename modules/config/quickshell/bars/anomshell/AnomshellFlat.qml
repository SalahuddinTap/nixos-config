//@ pragma UseQApplication
//@ pragma RespectSystemStyle
import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "modules"

PanelWindow {
    id: root

    screen: Quickshell.screens[0]

    property var hyprMonitor: Hyprland.monitorFor(screen)

    // Theme colors (OLED-friendly)
    property color bg:        "#1e1e2e"
    property color fg:        "#cdd6f4"
    property color accent:    "#89b4fa"
    property color dim:       "#45475a"
    property color highlight: "#cba6f7"
    property color red:       "#f38ba8"
    property color green:     "#a6e3a1"
    property color muted:     "#585b70"

    // Flat style (full-width, no margins, square corners)
    property bool flatStyle: true
    property int barHeight: 30
    property int edgeMargin: 0
    property int sideMargin: 0
    property int reservedSpace: 30
    property int barRadius: 0

    // Settings
    property var settings: ({
        barStyle: "flat",
        barPosition: "top",
        launcherIconPreset: "arch",
        launcherIconSize: 12
    })

    // Notification server
    NotificationServer {
        id: notifServer
    }

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 0
        bottom: 0
        left: 0
        right: 0
    }
    implicitHeight: root.barHeight
    exclusiveZone: root.reservedSpace
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: root.barRadius
        color: root.bg
        opacity: 1
        border.width: root.flatStyle ? 0 : 1
        border.color: Qt.rgba(1, 1, 1, 0.03)

        Item {
            id: leftSection
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: leftRow.implicitWidth

            Row {
                id: leftRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: ""
                    color: root.accent
                    font.pixelSize: 12
                    font.family: "JetBrainsMono Nerd Font Propo"
                }

                Workspaces {
                    anchors.verticalCenter: parent.verticalCenter
                    settings: root.settings
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        dim: root.dim,
                        muted: root.muted,
                        bg: root.bg
                    })
                }

                Media {
                    id: mediaModule
                    anchors.verticalCenter: parent.verticalCenter
                    accent: root.accent
                    fg: root.fg
                    green: root.green
                    muted: root.muted
                    dockBottom: false
                }
            }
        }

        Clock {
            anchors.centerIn: parent
            theme: ({
                fg: root.fg,
                muted: root.muted,
                accent: root.accent,
                dim: root.dim,
                bg: root.bg
            })
        }

        Item {
            id: rightSection
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: rightRow.implicitWidth

            Row {
                id: rightRow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12
                layoutDirection: Qt.RightToLeft

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: ""
                    font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font Propo"
                    color: root.muted
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰂚"
                    font.pixelSize: 14
                    font.family: "JetBrainsMono Nerd Font Propo"
                    color: root.muted
                }

                Tray {
                    anchors.verticalCenter: parent.verticalCenter
                    trayWindow: root
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        dim: root.dim,
                        muted: root.muted,
                        bg: root.bg
                    })
                }

                Stats {
                    anchors.verticalCenter: parent.verticalCenter
                    theme: ({
                        fg: root.fg,
                        accent: root.accent,
                        highlight: root.highlight,
                        dim: root.dim,
                        red: root.red,
                        green: root.green,
                        muted: root.muted,
                        bg: root.bg
                    })
                }

                Indicators {
                    anchors.verticalCenter: parent.verticalCenter
                    notifServer: root.notifServer
                    accent: root.accent
                    muted: root.muted
                    red: root.red
                    green: root.green
                    fg: root.fg
                }
            }
        }
    }
}