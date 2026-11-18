#!/usr/bin/env bash
# Rofi menu for Quickshell bars + CLI args.
# Usage: bar-switch.sh [island|widebar|widebar2|tripathi] (no args = rofi menu)
set -euo pipefail

ROFI_CONFIG="$HOME/.config/rofi/bar-menu.rasi"
MAIN_CONFIG="$HOME/.config/quickshell"
TRIPATHI_CONFIG="$HOME/.config/quickshell-tripathi"

# If argument provided, use it directly; otherwise show rofi menu
if [ -n "${1:-}" ]; then
choice="$1"
else
choice="$(printf '%s\n' \
"island" \
"widebar" \
"widebar2" \
"tripathi" \
| rofi -dmenu -config "$ROFI_CONFIG" -p "bar")"
fi

[ -z "$choice" ] && exit 0

# Kill existing quickshell instances
pkill -9 -f quickshell 2>/dev/null || true
# Wait for process to actually die
while pgrep -f quickshell >/dev/null 2>&1; do
sleep 0.1
done

case "$choice" in
island)
QS_ACTIVE_BAR=dynamicglacier quickshell -c "$MAIN_CONFIG" >/dev/null 2>&1 &
echo "Switched to island (dynamicglacier)"
;;
widebar)
QS_ACTIVE_BAR=widebar quickshell -c "$MAIN_CONFIG" >/dev/null 2>&1 &
echo "Switched to widebar"
;;
widebar2)
QS_ACTIVE_BAR=widebar2 quickshell -c "$MAIN_CONFIG" >/dev/null 2>&1 &
echo "Switched to widebar2"
;;
tripathi)
quickshell -c "$TRIPATHI_CONFIG" >/dev/null 2>&1 &
echo "Switched to tripathi (tripathiji1312/quickshell)"
;;
*)
echo "Unknown option: $choice (use island, widebar, widebar2 or tripathi)"
exit 1
;;
esac
