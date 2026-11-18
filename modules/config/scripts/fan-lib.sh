#!/usr/bin/env bash
# fan-lib.sh — shared fan-control helpers for MSI GF63 Thin 11UC (MS-16R6, EC fw 16R6EMS1.x)
#
# Why two backends:
#   The in-kernel msi-ec driver only whitelists specific EC firmware versions
#   (16R6EMS1.104 for this model). With other firmware (e.g. 16R6EMS1.10E) the
#   msi_ec module loads but does NOT create /sys/devices/platform/msi-ec.
#   In that case we fall back to the ec_sys module (write_support=1), which
#   exposes raw EC memory at /sys/kernel/debug/ec/ec0/io.
#
# EC registers for this model (msi-ec CONF12, BeardOverflow/msi-ec issue #72):
#   fan_mode      0xd4   auto=0x0d  silent=0x1d  advanced=0x8d  (basic unsupported)
#   shift_mode    0xd2   eco=0xc2   comfort=0xc1  sport=0xc0  turbo=0xc4
#   cooler_boost  0x98   bit 7 (observed: 0x06 = off, 0x86 = on)
#
# Env overrides (mainly for testing without root):
#   FAN_EC_SYSFS            override /sys/devices/platform/msi-ec
#   FAN_EC_SYS_IO           override the ec_sys io file
#   FAN_HWMON_ROOT          override /sys/class/hwmon
#   FAN_ALLOW_UNPRIVILEGED=1  do not re-exec via sudo

FAN_EC_SYSFS="${FAN_EC_SYSFS:-/sys/devices/platform/msi-ec}"
FAN_EC_SYS_IO="${FAN_EC_SYS_IO:-/sys/kernel/debug/ec/ec0/io}"
FAN_HWMON_ROOT="${FAN_HWMON_ROOT:-/sys/class/hwmon}"

EC_FAN_MODE=0xd4
EC_SHIFT_MODE=0xd2
EC_COOLER_BOOST=0x98

fan_need_root() {
  if [[ $EUID -ne 0 && "${FAN_ALLOW_UNPRIVILEGED:-0}" != "1" ]]; then
    exec sudo "$0" "$@"
  fi
}

# Make sure ec_sys is loaded (only possible as root). Best effort.
ensure_ec_sys() {
  if [[ ! -e "$FAN_EC_SYS_IO" && $EUID -eq 0 ]]; then
    modprobe ec_sys write_support=1 2>/dev/null || true
  fi
}

fan_backend_available() {
  [[ -d "$FAN_EC_SYSFS" && -w "$FAN_EC_SYSFS/fan_mode" ]] && return 0
  [[ -e "$FAN_EC_SYS_IO" ]] && return 0
  return 1
}

fan_backend_name() {
  if [[ -d "$FAN_EC_SYSFS" && -w "$FAN_EC_SYSFS/fan_mode" ]]; then
    echo "msi-ec sysfs ($FAN_EC_SYSFS)"
  elif [[ -e "$FAN_EC_SYS_IO" ]]; then
    echo "ec_sys ($FAN_EC_SYS_IO)"
  else
    echo "none"
  fi
}

# Find the hwmon device that reports fans: prefer msi_wmi_platform by name,
# fall back to any hwmon with a fan1_input.
fan_hwmon_dir() {
  local h name
  for h in "$FAN_HWMON_ROOT"/hwmon*; do
    [[ -d "$h" ]] || continue
    name=$(cat "$h/name" 2>/dev/null || true)
    if [[ "$name" == "msi_wmi_platform" ]]; then
      printf '%s' "$h"
      return 0
    fi
  done
  for h in "$FAN_HWMON_ROOT"/hwmon*; do
    if [[ -f "$h/fan1_input" ]]; then
      printf '%s' "$h"
      return 0
    fi
  done
  return 1
}

show_fans() {
  local h f rpm
  if h=$(fan_hwmon_dir); then
    echo "Current fan speeds:"
    for f in "$h"/fan*_input; do
      [[ -f "$f" ]] || continue
      rpm=$(cat "$f" 2>/dev/null || true)
      if [[ -n "$rpm" && "$rpm" -gt 0 ]]; then
        printf '  %-12s %s RPM\n' "${f##*/}" "$rpm"
      fi
    done
  else
    echo "No fan hwmon device found under $FAN_HWMON_ROOT" >&2
  fi
}

# --- raw EC access via ec_sys -------------------------------------------------

ec_hex() { # strips optional 0x prefix so $((16#...)) accepts it
  printf '%s' "${1#0x}"
}

ec_io_write() { # <addr-hex> <value-hex>
  printf "$(printf '\\x%02x' "$((16#$(ec_hex "$2")))")" | dd of="$FAN_EC_SYS_IO" bs=1 seek="$((16#$(ec_hex "$1")))" conv=notrunc status=none
}

ec_io_read() { # <addr-hex> -> prints value as 2-digit hex
  dd if="$FAN_EC_SYS_IO" bs=1 skip="$((16#$(ec_hex "$1")))" count=1 status=none | od -An -tx1 | tr -d ' \n'
}

# --- named settings (sysfs when available, raw EC otherwise) -------------------

ec_set_fan_mode() { # auto|silent|advanced
  local v
  case "$1" in
    auto)     v=0d ;;
    silent)   v=1d ;;
    advanced) v=8d ;;
    *) echo "unsupported fan_mode: $1" >&2; return 1 ;;
  esac
  if [[ -d "$FAN_EC_SYSFS" && -w "$FAN_EC_SYSFS/fan_mode" ]]; then
    echo "$1" > "$FAN_EC_SYSFS/fan_mode"
  else
    ec_io_write "$EC_FAN_MODE" "$v"
  fi
}

ec_set_shift_mode() { # eco|comfort|sport|turbo
  local v
  case "$1" in
    eco)     v=c2 ;;
    comfort) v=c1 ;;
    sport)   v=c0 ;;
    turbo)   v=c4 ;;
    *) echo "unsupported shift_mode: $1" >&2; return 1 ;;
  esac
  if [[ -d "$FAN_EC_SYSFS" && -w "$FAN_EC_SYSFS/shift_mode" ]]; then
    echo "$1" > "$FAN_EC_SYSFS/shift_mode"
  else
    ec_io_write "$EC_SHIFT_MODE" "$v"
  fi
}

ec_set_cooler_boost() { # on|off — read-modify-write bit 7 at 0x98
  local cur want
  if [[ -d "$FAN_EC_SYSFS" && -w "$FAN_EC_SYSFS/cooler_boost" ]]; then
    echo "$1" > "$FAN_EC_SYSFS/cooler_boost"
    return 0
  fi
  cur=$(ec_io_read "$EC_COOLER_BOOST")
  if [[ "$1" == "on" ]]; then
    want=$(( 0x$cur | 0x80 ))
  else
    want=$(( 0x$cur & 0x7f ))
  fi
  ec_io_write "$EC_COOLER_BOOST" "$(printf '%02x' "$want")"
}

# --- profiles ------------------------------------------------------------------

set_profile() { # max|middle|silent
  case "$1" in
    max)
      ec_set_fan_mode advanced
      ec_set_shift_mode turbo
      ec_set_cooler_boost on
      ;;
    middle)
      ec_set_fan_mode auto
      ec_set_shift_mode comfort
      ec_set_cooler_boost off
      ;;
    silent)
      ec_set_fan_mode silent
      ec_set_shift_mode eco
      ec_set_cooler_boost off
      ;;
    *)
      echo "Usage: set_profile {max|middle|silent}" >&2
      return 1
      ;;
  esac
}
