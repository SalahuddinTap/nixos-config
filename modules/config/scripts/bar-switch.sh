#!/usr/bin/env bash
# Switch the Quickshell bar (single switcher — uses QS_ACTIVE_BAR env + quickshell from PATH).
# Usage: bar-switch.sh [island|wide|widebar2|status]
set -u

CONFIG="$HOME/.config/quickshell"
# Match the full cmdline: on NixOS the binary is wrapped, so the process name
# is ".quickshell-wra" and `pkill -x quickshell` never matches.
QS_PROC="quickshell -c $CONFIG"

case "${1:-}" in
  island)   BAR=dynamicglacier ;;
  wide)     BAR=widebar ;;
  widebar2) BAR=widebar2 ;;
  status)
    if pgrep -f "$QS_PROC" >/dev/null 2>&1; then
      echo "quickshell running (QS_ACTIVE_BAR at launch decides the bar)"
    else
      echo "quickshell not running"
    fi
    exit 0
    ;;
  "")
    echo "Usage: $0 [island|wide|widebar2|status]"
    exit 1
    ;;
  *)
    echo "Unknown bar: $1 (use island, wide or widebar2)"
    exit 1
    ;;
esac

pkill -9 -f "$QS_PROC" 2>/dev/null
sleep 0.5
QS_ACTIVE_BAR="$BAR" quickshell -c "$CONFIG" >/dev/null 2>&1 &
echo "Switched to $1 ($BAR)"
