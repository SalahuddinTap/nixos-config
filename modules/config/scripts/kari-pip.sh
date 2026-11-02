#!/usr/bin/env bash
# kari PiP — toggle active window (mpv) between floating pinned corner and normal
# Usage: bind Super+P to this script in Hyprland

# Get active window info
ACTIVE=$(hyprctl activewindow -j)
ADDR=$(echo "$ACTIVE" | jq -r '.address')
CLASS=$(echo "$ACTIVE" | jq -r '.class')

# Check if already floating & pinned
IS_FLOATING=$(echo "$ACTIVE" | jq -r '.floating')
IS_PINNED=$(hyprctl getprop "$ADDR" pinned 2>/dev/null || echo "false")

if [ "$IS_FLOATING" = "true" ] && [ "$IS_PINNED" = "true" ]; then
    # Unpin and unfloat — restore to normal tiling
    hyprctl dispatch pin "$ADDR"
    hyprctl dispatch togglefloating "$ADDR"
    hyprctl dispatch resizeactive exact 80% 80%
    hyprctl dispatch centerwindow
else
    # Float, pin to bottom-right corner, resize to small PiP size
    hyprctl dispatch togglefloating "$ADDR"
    hyprctl dispatch pin "$ADDR"
    # Move to bottom-right with margin
    hyprctl dispatch movewindowpixel exact "e-520" "e-320" "$ADDR"
    hyprctl dispatch resizeactive exact 500 300 "$ADDR"
    # Keep on all workspaces
    hyprctl dispatch movetoworkspacesilent special
fi
