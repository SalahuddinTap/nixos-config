#!/usr/bin/env bash
# QuickShell bar switcher
# Usage: switch-bar.sh [hyprminimal|dynamicglacier|anomshell|bar-pill|bar-island|bar-wide]

BAR_FILE="/tmp/quickshell-active-bar"

# Map aliases to actual bar names
case "${1:-}" in
    hyprminimal|bar-pill)
        echo "hyprminimal" > "$BAR_FILE"
        echo "Switched to hyprminimal (pill)"
        echo "Restart quickshell to apply: pkill quickshell && quickshell &"
        ;;
    dynamicglacier|bar-island)
        echo "dynamicglacier" > "$BAR_FILE"
        echo "Switched to dynamicglacier (island)"
        echo "Restart quickshell to apply: pkill quickshell && quickshell &"
        ;;
    anomshell|bar-wide)
        echo "anomshell" > "$BAR_FILE"
        echo "Switched to anomshell (wide)"
        echo "Restart quickshell to apply: pkill quickshell && quickshell &"
        ;;
    "")
        if [[ -f "$BAR_FILE" ]]; then
            current=$(cat "$BAR_FILE")
            # Show friendly name
            case "$current" in
                hyprminimal) echo "Current bar: hyprminimal (pill)" ;;
                dynamicglacier) echo "Current bar: dynamicglacier (island)" ;;
                anomshell) echo "Current bar: anomshell (wide)" ;;
                *) echo "Current bar: $current" ;;
            esac
        else
            echo "Current bar: hyprminimal (pill)"
        fi
        echo "Usage: $0 [hyprminimal|dynamicglacier|anomshell|bar-pill|bar-island|bar-wide]"
        ;;
    *)
        echo "Unknown bar: $1"
        echo "Usage: $0 [hyprminimal|dynamicglacier|anomshell|bar-pill|bar-island|bar-wide]"
        exit 1
        ;;
esac