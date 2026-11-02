//@ pragma UseQApplication
//@ pragma RespectSystemStyle
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "modules"

Scope {
    id: root

    // Dependencies
    property var hyprMonitor: null
    property var settingsObj: null

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

    // Notification server
    NotificationServer {
        id: notifServer
        keepOnReload: true
    }

    // Settings state (minimal)
    property var settings: Qt.binding(function() {
        return {
            barStyle: "flat",
            barPosition: "top",
            launcherIconPreset: "arch",
            launcherIconSize: 12
        }
    })

    // Launcher reference (can be connected externally)
    property var launcher: null

    // Main bar
    PanelWindow {
        id: bar
        screen: root.hyprMonitor ? root.hyprMonitor.screen : null

        anchors {
            top: !root.settings.barPosition || root.settings.barPosition === "top"
            bottom: root.settings.barPosition === "bottom"
            left: true
            right: true
        }
        margins {
            top: (root.settings.barPosition === "bottom" ? 0 : root.edgeMargin)
            bottom: (root.settings.barPosition === "bottom" ? root.edgeMargin : 0)
            left: root.sideMargin
            right: root.sideMargin
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

            Behavior on color { ColorAnimation { duration: 400; easing.type: Easing.OutCubic } }

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

                    // Launcher icon
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: (root.settings.launcherIconPreset === "arch") ? "" :
                              (root.settings.launcherIconPreset === "hyprland") ? "" :
                              (root.settings.launcherIconPreset === "nix") ? "" :
                              (root.settings.launcherIconPreset === "command") ? "󰘳" :
                              (root.settings.launcherIconPreset === "windows") ? "󰖳" : "\ue900"
                        color: root.accent
                        font.pixelSize: root.settings.launcherIconSize
                        font.family: root.settings.launcherIconPreset === "omarchy" ? "Omarchy" : "JetBrainsMono Nerd Font Propo"
                        Behavior on color { ColorAnimation { duration: 400; easing.type: Easing.OutCubic } }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.launcher) root.launcher.showing = !root.launcher.showing
                            }
                        }
                    }

                    // Workspaces
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

                    // Separator
                    Rectangle {
                        width: 1
                        height: 10
                        color: root.dim
                        opacity: 0.5
                        anchors.verticalCenter: parent.verticalCenter
                        visible: mediaModule.hasMedia
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }

                    // Media
                    Media {
                        id: mediaModule
                        anchors.verticalCenter: parent.verticalCenter
                        accent: root.accent
                        fg: root.fg
                        green: root.green
                        muted: root.muted
                        dockBottom: root.settings.barPosition === "bottom"
                    }
                }
            }

            // Clock center
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

            // Right section
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

                    // Control center toggle
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ""
                        font.pixelSize: 13
                        font.family: "JetBrainsMono Nerd Font Propo"
                        color: controlCenterModule.showing ? root.accent : root.muted
                        Behavior on color { ColorAnimation { duration: 150 } }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: controlCenterModule.showing = !controlCenterModule.showing
                        }
                    }

                    // Notifications
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.notifServer && root.notifServer.dndEnabled
                            ? "󰂛"
                            : root.notifServer && root.notifServer.notifications.length > 0
                                ? "󱅫"
                                : "󰂚"
                        font.pixelSize: 14
                        font.family: "JetBrainsMono Nerd Font Propo"
                        color: root.notifServer && root.notifServer.dndEnabled
                            ? root.red
                            : root.notifServer && root.notifServer.panelOpen
                                ? root.accent
                                : root.muted
                        Behavior on color { ColorAnimation { duration: 150 } }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: mouse => {
                                if (!root.notifServer) return
                                if (mouse.button === Qt.RightButton) root.notifServer.toggleDnd()
                                else root.notifServer.togglePanel()
                            }
                        }
                    }

                    // System tray
                    Tray {
                        anchors.verticalCenter: parent.verticalCenter
                        trayWindow: bar
                        theme: ({
                            fg: root.fg,
                            accent: root.accent,
                            dim: root.dim,
                            muted: root.muted,
                            bg: root.bg
                        })
                    }

                    Rectangle {
                        width: 1
                        height: 12
                        color: root.dim
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }

                    // Stats (CPU/RAM)
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

                    Rectangle {
                        width: 1
                        height: 12
                        color: root.dim
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }

                    // Indicators (volume, brightness, battery, etc.)
                    Indicators {
                        anchors.verticalCenter: parent.verticalCenter
                        notifServer: root.notifServer
                        accent: root.accent
                        muted: root.muted
                        red: root.red
                        green: root.green
                        fg: root.fg
                    }

                    // Control Center
                    ControlCenter {
                        id: controlCenterModule
                        notifServer: root.notifServer
                        theme: ({
                            fg: root.fg,
                            accent: root.accent,
                            dim: root.dim,
                            muted: root.muted,
                            bg: root.bg,
                            red: root.red,
                            green: root.green,
                            highlight: root.highlight
                        })
                    }
                }
            }
        }
    }
}