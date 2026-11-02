import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: barWindow
            property var modelData
            screen: modelData
            layer: "top"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 36
            visible: true
            
            // Auto-hide for OLED (optional - toggle via IPC)
            property bool autoHide: false
            property int hideTimer: 0
            
            Rectangle {
                anchors.fill: parent
                color: "#000000"
                opacity: 0.92
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    
                    // Workspaces
                    WorkspaceButton {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                        model: Hyprland.workspaces
                        delegate: Item {
                            width: 32
                            height: 28
                            Rectangle {
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                radius: 4
                                color: modelData.id === Hyprland.activeWorkspace?.id ? "#ffffff" : "#333333"
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.id
                                    color: modelData.id === Hyprland.activeWorkspace?.id ? "#000000" : "#ffffff"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch(`workspace ${modelData.id}`)
                            }
                        }
                    }
                    
                    // Spacer
                    Item { Layout.fillWidth: true }
                    
                    // Clock
                    Text {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        text: Qt.formatTime(Date.now(), "HH:mm")
                        color: "#ffffff"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                    }
                    
                    // Spacer
                    Item { Layout.fillWidth: true }
                    
                    // System tray (right side)
                    Tray {
                        Layout.alignment: Qt.AlignRight
                        iconSize: 20
                        spacing: 8
                    }
                }
            }
        }
    }
}
