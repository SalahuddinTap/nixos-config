//@ pragma UseQApplication
//@ pragma RespectSystemStyle
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: root
    property string font: "JetBrainsMono Nerd Font Mono"

    Component {
        id: workspaceDots
        Item {
            id: wsRoot
            height: 32
            Layout.alignment: Qt.AlignVCenter

            property var allWorkspaces: Hyprland.workspaces.values
            property int activeId: (Hyprland.active && Hyprland.active.workspace) ? Hyprland.active.workspace.id : 1

            function getFiltered() {
                var out = [];
                var seen = {};
                var wss = wsRoot.allWorkspaces;
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
                spacing: -4
                Layout.leftMargin: 8

                Repeater {
                    model: wsRoot.getFiltered()
                    delegate: Item {
                        required property var modelData
                        readonly property int wsId: modelData.id
                        readonly property bool isActive: modelData.id === wsRoot.activeId
                        height: 32
                        width: 20
                        Layout.alignment: Qt.AlignVCenter

                        property real dotScale: isActive ? 1.0 : 0.8
                        property real dotOpacity: isActive ? 1.0 : 0.7

                        Behavior on dotScale {
                            SpringAnimation {
                                spring: 2.5
                                damping: 0.75
                                velocity: 0
                                mass: 1
                            }
                        }
                        Behavior on dotOpacity {
                            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                        }

                        property real hoverScale: 1.0

                        Rectangle {
                            id: dot
                            anchors.centerIn: parent
                            width: 12 * dotScale * hoverScale
                            height: width
                            radius: width / 2
                            color: isActive ? "#ffffff" : "#888888"
                            opacity: dotOpacity
                            antialiasing: true
                        }

                        MouseArea {
                            id: clickArea
                            anchors.fill: parent
                            anchors.margins: -8
                            cursorShape: isActive ? Qt.ArrowCursor : Qt.PointingHandCursor
                            hoverEnabled: true

                            onEntered: {
                                if (!isActive) {
                                    parent.hoverScale = 1.2
                                }
                            }
                            onExited: {
                                parent.hoverScale = 1.0
                            }
                            onPressed: {
                                if (!isActive) {
                                    parent.hoverScale = 0.9
                                }
                            }
                            onReleased: {
                                if (!isActive) {
                                    parent.hoverScale = 1.2
                                }
                            }
                            onClicked: {
                                if (!isActive) {
                                    Hyprland.messageAsync("dispatch", "workspace " + wsId)
                                }
                            }
                        }

                        Text {
                            id: numberLabel
                            visible: !isActive && clickArea.containsMouse
                            anchors.centerIn: parent
                            text: wsId <= 9 ? wsId : ""
                            font.family: "JetBrainsMono Nerd Font Mono"
                            font.pixelSize: 9
                            font.weight: Font.Medium
                            color: "#ffffff"
                            opacity: 0
                            Behavior on opacity { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                            onVisibleChanged: opacity = visible ? 1.0 : 0.0
                        }
                    }
                }
            }
        }
    }

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

            Loader { sourceComponent: workspaceDots }

            Item { Layout.fillWidth: true }

            Item {
                height: 32
                Layout.alignment: Qt.AlignVCenter

                Timer { interval: 1000; running: true; repeat: true; onTriggered: timeText.text = Qt.formatTime(new Date(), "HH:mm") }

                Text {
                    id: timeText
                    text: Qt.formatTime(new Date(), "HH:mm")
                    font.family: root.font
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: "#ffffff"
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item { Layout.fillWidth: true }
        }
    }
}