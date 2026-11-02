import QtQuick

// Material Symbols Rounded helper.
// Requires the "Material Symbols Rounded" font (nixpkgs: material-symbols,
// enabled via fonts.packages in modules/desktop.nix).
// Usage:
//   MIcon { name: "battery_full"; size: 14; color: "white" }
//   MIcon { name: "mic"; size: 12; filled: true }
Text {
    id: root

    property string name: ""
    property real size: 14
    property bool filled: false

    text: name
    color: "#f5f5f5"
    font.family: "Material Symbols Rounded"
    font.pixelSize: size
    font.weight: filled ? Font.Bold : Font.Medium
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    renderType: Text.QtRendering
    antialiasing: true
}
