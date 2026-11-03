#!/usr/bin/env bash
# Switch the Quickshell bar (single switcher — uses QS_ACTIVE_BAR env + quickshell from PATH).
# Usage: bar-switch.sh [island|wide|status]
set -u

CONFIG="$HOME/.config/quickshell"

case "${1:-}" in
  island) BAR=dynamicglacier ;;
  wide)   BAR=anomshell ;;
  status)
    if pgrep -x quickshell >/dev/null 2>&1; then
      echo "quickshell running (QS_ACTIVE_BAR at launch decides the bar)"
    else
      echo "quickshell not running"
    fi
    exit 0
    ;;
  "")
    echo "Usage: $0 [island|wide|status]"
    exit 1
    ;;
  *)
    echo "Unknown bar: $1 (use island or wide)"
    exit 1
    ;;
esac

pkill -x quickshell 2>/dev/null
sleep 0.5
QS_ACTIVE_BAR="$BAR" quickshell -c "$CONFIG" >/dev/null 2>&1 &
echo "Switched to $1 ($BAR)"
