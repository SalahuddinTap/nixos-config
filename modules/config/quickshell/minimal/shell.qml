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
            color: "transparent"
            implicitHeight: 36
            
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell:minimal-bar"
            
            anchors.top: true
            anchors.left: true
            anchors.right: true
            
            Rectangle {
                anchors.fill: parent
                color: "#000000"
                opacity: 0.92
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    
                    // Workspaces
                    Repeater {
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
                        text: Qt.formatDateTime(new Date(), "HH:mm")
                        color: "#ffffff"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                    }
                    
                    // Spacer
                    Item { Layout.fillWidth: true }
                    
                    // Battery indicator (simple)
                    Text {
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        text: "🔋 85%"
                        color: "#ffffff"
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
