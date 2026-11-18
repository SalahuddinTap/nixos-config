#!/usr/bin/env bash
# power-menu.sh — rofi menu with 3 power presets, wired to CPU profiles + MSI fans.
#   1 Battery Saver : power-saver CPU + silent fans
#   2 Middle        : balanced CPU  + middle fans
#   3 Absolute Max  : performance CPU + cooler-boost fans (max RPM)
# The chosen fan profile is also written to boot/profile so it applies at next boot.
set -euo pipefail

CMD_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE_FILE="$CMD_DIR/boot/profile"

set_cpu_profile() { # power-saver|balanced|performance
  if command -v powerprofilesctl >/dev/null 2>&1 && systemctl is-active --quiet power-profiles-daemon; then
    powerprofilesctl set "$1"
  else
    # Fallback: write the governor directly (Intel P-state)
    local gov="$1"
    [[ "$gov" == "power-saver" ]] && gov="powersave"
    [[ "$gov" == "performance" ]] && gov="performance"
    [[ "$gov" == "balanced" ]] && gov="ondemand"
    for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
      echo "$gov" | sudo tee "$f" >/dev/null
    done
  fi
}

apply_preset() { # saver|middle|max
  case "$1" in
    saver)
      set_cpu_profile power-saver
      "$CMD_DIR/fan-silent.sh" >/dev/null
      echo silent > "$PROFILE_FILE"
      notify-send "🔋 Battery Saver" "CPU: power-saver · Fans: silent" ;;
    middle)
      set_cpu_profile balanced
      "$CMD_DIR/fan-middle.sh" >/dev/null
      echo middle > "$PROFILE_FILE"
      notify-send "⚖️ Middle" "CPU: balanced · Fans: middle" ;;
    max)
      set_cpu_profile performance
      "$CMD_DIR/fan-max.sh" >/dev/null
      echo max > "$PROFILE_FILE"
      notify-send "🚀 ABSOLUTE MAX" "CPU: performance · Fans: cooler boost (max RPM)" ;;
  esac
}

choice=$(printf '%s\n' \
  "🔋  Battery Saver — powersave CPU + silent fans" \
  "⚖️  Middle — balanced CPU + middle fans" \
  "🚀  Absolute Max — performance CPU + cooler boost (10k RPM)" \
  | rofi -dmenu -p "Power mode" -theme-str '* { font: "JetBrainsMono Nerd Font 14"; }')

case "$choice" in
  *"Battery Saver"*) apply_preset saver ;;
  *"Middle"*)        apply_preset middle ;;
  *"Absolute Max"*)  apply_preset max ;;
  *) exit 0 ;;
esac
