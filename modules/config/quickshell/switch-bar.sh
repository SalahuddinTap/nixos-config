#!/usr/bin/env bash
# QuickShell bar switcher
# Usage: switch-bar.sh [hyprminimal|dynamicglacier]

BAR_FILE="/tmp/quickshell-active-bar"

case "${1:-}" in
    hyprminimal|dynamicglacier)
        echo "$1" > "$BAR_FILE"
        echo "Switched to $1 bar"
        echo "Restart quickshell to apply: pkill quickshell && quickshell &"
        ;;
    "")
        if [[ -f "$BAR_FILE" ]]; then
            echo "Current bar: $(cat "$BAR_FILE")"
        else
            echo "Current bar: hyprminimal (default)"
        fi
        echo "Usage: $0 [hyprminimal|dynamicglacier]"
        ;;
    *)
        echo "Unknown bar: $1"
        echo "Usage: $0 [hyprminimal|dynamicglacier]"
        exit 1
        ;;
esac