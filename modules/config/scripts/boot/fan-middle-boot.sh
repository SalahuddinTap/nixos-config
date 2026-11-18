#!/usr/bin/env bash
# boot/fan-middle-boot.sh — applied at BOOT: fans to MIDDLE (balanced)
# (auto + comfort + cooler_boost off). Safe: never shuts down on failure.
set -euo pipefail

EC=/sys/devices/platform/msi-ec

if [[ $EUID -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

if [[ ! -d "$EC" ]]; then
  echo "msi-ec not loaded at boot — skipping (run: sudo modprobe msi_ec)" >&2
  exit 0
fi

read -r FAN_MODES < "$EC/available_fan_modes"
read -r SHIFT_MODES < "$EC/available_shift_modes"

[[ " $FAN_MODES " == *" auto "* ]]    && echo auto    > "$EC/fan_mode"    || echo "fan_mode 'auto' not supported, skipping" >&2
[[ " $SHIFT_MODES " == *" comfort "* ]] && echo comfort > "$EC/shift_mode"  || echo "shift_mode 'comfort' not supported, skipping" >&2
echo off > "$EC/cooler_boost" 2>/dev/null || true

echo "Boot profile applied: MIDDLE"
