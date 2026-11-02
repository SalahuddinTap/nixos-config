//@ pragma UseQApplication
//@ pragma RespectSystemStyle
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: root
    property string font: "JetBrainsMono Nerd Font Mono"

    PanelWindow {
        id: bar
        exclusiveZone: 32
        color: "#000000"
        anchors { top: true; left: true; right: true }
        implicitHeight: 32

        RowLayout {
            anchors.fill: parent
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            // Left: Workspaces
            Item {
                id: wsContainer
                height: 32
                Layout.alignment: Qt.AlignVCenter

                property var workspaces: Hyprland.workspaces.values
                property int activeId: Hyprland.active.workspace.id

                readonly property var filtered: {
                    var out = [];
                    var seen = {};
                    var wss = workspaces;
                    for (var i = 0; i < wss.length; i++) {
                        var w = wss[i];
                        if (w.id >= 1 && w.monitor && !seen[w.id]) {
                            seen[w.id] = true;
                            out.push(w);
                        }
                    }
                    out.sort(function(a, b) { return a.id - b.id; });
                    return out;
                }

                RowLayout {
                    id: wsRow
                    height: parent.height
                    spacing: 4

                    Repeater {
                        model: wsContainer.filtered
                        delegate: Item {
                            id: wsItem
                            required property var modelData
                            readonly property int wsId: modelData.id
                            readonly property bool isActive: modelData.id === wsContainer.activeId
                            Layout.preferredWidth: isActive ? 28 : 24
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignVCenter

                            Rectangle {
                                id: dot
                                anchors.centerIn: parent
                                width: isActive ? 8 : 6
                                height: isActive ? 8 : 6
                                radius: width / 2
                                color: isActive ? "#ffffff" : "#444444"
                                Behavior on color { NumberAnimation { duration: 150 } }
                                Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -4
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.messageAsync("dispatch", "workspace " + wsItem.wsId)
                            }
                        }
                    }
                }
            }

            // Center spacer
            Item { Layout.fillWidth: true }

            // Center: Clock
            Item {
                height: 32
                Layout.alignment: Qt.AlignVCenter
                Timer { interval: 1000; running: true; repeat: true; onTriggered: timeText.text = Qt.formatTime(new Date(), "HH:mm:ss") }
                Text {
                    id: timeText
                    text: Qt.formatTime(new Date(), "HH:mm:ss")
                    font.family: root.font
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: "#ffffff"
                }
            }

            // Right spacer
            Item { Layout.fillWidth: true }
        }
    }
}