#!/usr/bin/env bash
# boot/apply-boot-profile.sh — applied at BOOT by msi-fan-boot.service (NixOS).
# Reads the profile from ./profile (max|middle|silent|off) and applies it.
# Safe: never fails the boot unit.
set -uo pipefail

SELF_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
# shellcheck source=../fan-lib.sh
source "$SELF_DIR/../fan-lib.sh"

PROFILE_FILE="$SELF_DIR/profile"
profile=$(tr -d '[:space:]' < "$PROFILE_FILE" 2>/dev/null || true)

if [[ -z "$profile" || "$profile" == "off" ]]; then
  echo "Boot fan profile: off (no changes made)"
  exit 0
fi

fan_need_root "$@"
ensure_ec_sys

if ! fan_backend_available; then
  echo "No fan control backend at boot — skipping (backend: $(fan_backend_name))" >&2
  exit 0
fi

if set_profile "$profile"; then
  echo "Boot profile applied: $profile (via $(fan_backend_name))"
else
  echo "Boot profile $profile failed — continuing boot anyway" >&2
fi
exit 0
