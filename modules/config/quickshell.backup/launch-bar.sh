#!/bin/bash
# Quickshell launcher - uses timeout to properly daemonize

export QML2_IMPORT_PATH="/nix/store/30w7sm9xa1m7xp4rs6swxdand90w2gjj-qt5compat-6.12.0/lib/qt-6/qml"
export QT_QUICK_CONTROLS_STYLE=Basic
export QS_NO_RELOAD_POPUP=1

QS_CMD="/nix/store/5zjsqdacgkfk1vif63cil60y023b3vnp-quickshell-0.3.2/bin/quickshell"

BAR="${1:-hyprminimal}"

# Kill existing
pkill -f quickshell 2>/dev/null
sleep 1

# Launch with timeout to properly daemonize (timeout exits but child stays)
timeout 1 "$QS_CMD" -c "$BAR" -d > /dev/null 2>&1 &
sleep 2
