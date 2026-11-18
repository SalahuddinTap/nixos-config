#!/usr/bin/env bash
# fan-middle.sh — set MSI GF63 Thin 11UC fans to MIDDLE (balanced)
# Uses msi-ec kernel module sysfs: fan_mode=auto, shift_mode=comfort, cooler_boost=off
set -euo pipefail

EC=/sys/devices/platform/msi-ec

if [[ $EUID -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

if [[ ! -d "$EC" ]]; then
  echo "msi-ec not loaded. Run: sudo modprobe msi_ec" >&2
  exit 1
fi

echo "Setting fans to MIDDLE (auto + comfort + cooler boost off)…"
echo auto    > "$EC/fan_mode"
echo comfort > "$EC/shift_mode"
echo off     > "$EC/cooler_boost"

echo "Done. Current fan speeds:"
for f in fan1_input fan2_input fan3_input fan4_input; do
  rpm=$(cat "/sys/class/hwmon/hwmon4/$f" 2>/dev/null)
  [[ -n "$rpm" && "$rpm" -gt 0 ]] && printf "  %-12s %s RPM\n" "$f" "$rpm"
done