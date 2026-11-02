#!/usr/bin/env bash
# Clipboard history via cliphist + rofi
# Bind to a key in hyprland (e.g., SUPER+SHIFT+V)

set -euo pipefail

# Show clipboard history in rofi with Catppuccin Mocha theme
# Prepend "Clear History" option
selected=$(
  {
    echo "🗑 Clear History"
    cliphist list
  } | rofi -dmenu -i -p "Clipboard" \
    -theme-str '
      window {width: 60%; background-color: #1e1e2e; border: 2px; border-color: #89b4fa;}
      mainbox {background-color: #1e1e2e;}
      listview {lines: 12; background-color: #181825; border: 0px;}
      element {background-color: #181825; text-color: #cdd6f4;}
      element selected {background-color: #313244; text-color: #a6e3a1;}
      inputbar {background-color: #1e1e2e; text-color: #cdd6f4; border: 1px; border-color: #313244;}
      prompt {text-color: #89b4fa;}
    '
)

# Exit if nothing selected
[ -z "$selected" ] && exit 0

# Handle special actions
case "$selected" in
  "🗑 Clear History")
    cliphist wipe
    notify-send "Clipboard" "History cleared" -i edit-clear
    exit 0
    ;;
esac

# Decode and copy to clipboard
cliphist decode <<<"$selected" | wl-copy