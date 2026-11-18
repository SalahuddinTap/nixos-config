#!/usr/bin/env bash
# boot/fan-max-boot.sh — applied at BOOT: fans to MAXIMUM
# (advanced + turbo + cooler_boost on). Safe: never shuts down on failure.
set -euo pipefail

EC=/sys/devices/platform/msi-ec

if [[ $EUID -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

if [[ ! -d "$EC" ]]; then
  echo "msi-ec not loaded at boot — skipping (run: sudo modprobe msi_ec)" >&2
  exit 0   # do NOT fail the boot unit over a missing module
fi

# Only write modes the firmware actually advertises.
read -r FAN_MODES < "$EC/available_fan_modes"
read -r SHIFT_MODES < "$EC/available_shift_modes"

[[ " $FAN_MODES " == *" advanced "* ]]  && echo advanced > "$EC/fan_mode"      || echo "fan_mode 'advanced' not supported, skipping" >&2
[[ " $SHIFT_MODES " == *" turbo "* ]]    && echo turbo     > "$EC/shift_mode"    || echo "shift_mode 'turbo' not supported, skipping" >&2
echo on > "$EC/cooler_boost" 2>/dev/null || echo "cooler_boost write failed, skipping" >&2

echo "Boot profile applied: MAX"
