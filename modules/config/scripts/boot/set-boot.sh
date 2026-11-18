#!/usr/bin/env bash
# boot/set-boot.sh — pick which fan profile runs at BOOT.
# Usage:  set-boot.sh max | middle | silent | off | status
#
#   max      -> fans MAXIMUM on every boot
#   middle   -> fans balanced on every boot
#   silent   -> fans silent on every boot
#   off      -> nothing runs at boot (you control fans manually)
#   status   -> show what's currently set for boot
#
# This only changes what happens at BOOT. To change fan speed right now,
# run the manual scripts in ~/.local/bin/ (fan-max.sh, fan-middle.sh, fan-silent.sh).
set -euo pipefail

PROFILES=(max middle silent)
CMD_DIR="$(cd "$(dirname "$0")" && pwd)"

need_root() {
  if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
  fi
}

case "${1:-status}" in
  max|middle|silent)
    need_root "$@"
    # Disable the other two, enable the chosen one.
    for p in "${PROFILES[@]}"; do
      if [[ "$p" == "$1" ]]; then
        systemctl enable "fan-$p-boot.service"
        echo "Boot profile set to: $1 (enabled)"
      else
        systemctl disable "fan-$p-boot.service" 2>/dev/null || true
      fi
    done
    echo "Apply it now without rebooting:  ~/.local/bin/fan-$1.sh"
    ;;
  off)
    need_root "$@"
    for p in "${PROFILES[@]}"; do
      systemctl disable "fan-$p-boot.service" 2>/dev/null || true
    done
    echo "No fan profile will run at boot. Control fans manually with ~/.local/bin/fan-*.sh"
    ;;
  status)
    echo "Boot fan profile status:"
    for p in "${PROFILES[@]}"; do
      state=$(systemctl is-enabled "fan-$p-boot.service" 2>/dev/null || echo disabled)
      printf "  %-7s %s\n" "$p" "$state"
    done
    echo ""
    echo "Manual scripts (run anytime, override until next boot):"
    ls "$CMD_DIR"/../fan-*.sh 2>/dev/null | sed 's/^/  /'
    ;;
  *)
    echo "Usage: $0 {max|middle|silent|off|status}" >&2
    exit 1
    ;;
esac
