#!/usr/bin/env node
// Bar Switcher for Quickshell
// Usage: bar-switch.js [hyprminimal|dynamicglacier|toggle|status]

import { spawn, execSync } from 'child_process';
import { existsSync, readFileSync, writeFileSync } from 'fs';
import { homedir } from 'os';

const CONFIG_DIR = `${homedir()}/.config/quickshell`;
const STATE_FILE = `${CONFIG_DIR}/.active-bar`;

const AVAILABLE_BARS = ['hyprminimal', 'dynamicglacier'];

const QS_CMD = '/nix/store/5zjsqdacgkfk1vif63cil60y023b3vnp-quickshell-0.3.2/bin/quickshell';
const QML2_PATH = '/nix/store/30w7sm9xa1m7xp4rs6swxdand90w2gjj-qt5compat-6.12.0/lib/qt-6/qml';

function getActiveBar() {
    if (existsSync(STATE_FILE)) {
        return readFileSync(STATE_FILE, 'utf8').trim();
    }
    return 'hyprminimal';
}

function setActiveBar(bar) {
    writeFileSync(STATE_FILE, bar);
}

function isValidBar(bar) {
    return AVAILABLE_BARS.includes(bar);
}

function killQuickshell() {
    try {
        execSync('pkill -f quickshell', { stdio: 'ignore' });
    } catch {}
}

function startQuickshell(bar) {
    const env = { 
        ...process.env, 
        QML2_IMPORT_PATH: QML2_PATH,
        QT_QUICK_CONTROLS_STYLE: 'Basic',
        QS_NO_RELOAD_POPUP: '1'
    };
    // Use setsid to properly daemonize
    const child = spawn('setsid', [QS_CMD, '-c', bar, '-d'], {
        detached: true,
        stdio: 'ignore',
        env
    });
    child.unref();
    return child;
}

function switchBar(targetBar) {
    if (!isValidBar(targetBar)) {
        console.error(`Invalid bar: ${targetBar}`);
        console.error(`Available: ${AVAILABLE_BARS.join(', ')}`);
        process.exit(1);
    }

    const currentBar = getActiveBar();
    if (currentBar === targetBar) {
        console.log(`Already using ${targetBar}`);
        return;
    }

    console.log(`Switching: ${currentBar} → ${targetBar}`);
    
    killQuickshell();
    
    setTimeout(() => {
        setActiveBar(targetBar);
        startQuickshell(targetBar);
        console.log(`Started ${targetBar}`);
    }, 300);
}

function toggleBar() {
    const current = getActiveBar();
    const idx = AVAILABLE_BARS.indexOf(current);
    const next = AVAILABLE_BARS[(idx + 1) % AVAILABLE_BARS.length];
    switchBar(next);
}

function status() {
    const active = getActiveBar();
    console.log(`Active bar: ${active}`);
    console.log(`Available: ${AVAILABLE_BARS.join(', ')}`);
}

function installKeybinds() {
    console.log(`
# Add to your hyprland.conf binds section:

# Switch to hyprminimal (auto-hiding, OLED-friendly)
bind = SUPER, F1, exec, node ${CONFIG_DIR}/bar-switch.js hyprminimal

# Switch to dynamicglacier (animated island)
bind = SUPER, F2, exec, node ${CONFIG_DIR}/bar-switch.js dynamicglacier

# Toggle between bars
bind = SUPER, F3, exec, node ${CONFIG_DIR}/bar-switch.js toggle

# Show status
bind = SUPER, SHIFT, F3, exec, node ${CONFIG_DIR}/bar-switch.js status
`);
}

// CLI
const args = process.argv.slice(2);
const command = args[0];

switch (command) {
    case 'hyprminimal':
    case 'dynamicglacier':
        switchBar(command);
        break;
    case 'toggle':
        toggleBar();
        break;
    case 'status':
        status();
        break;
    case 'install-keybinds':
        installKeybinds();
        break;
    default:
        console.log(`
Quickshell Bar Switcher
Usage: bar-switch.js <command>

Commands:
  hyprminimal       Switch to hyprminimal bar (auto-hiding, OLED-friendly)
  dynamicglacier    Switch to DynamicGlacier bar (animated island)
  toggle            Toggle between bars
  status            Show current bar status
  install-keybinds  Print Hyprland keybinds to add

Example keybinds (add to hyprland.conf):
  bind = SUPER, F1, exec, node ~/.config/quickshell/bar-switch.js hyprminimal
  bind = SUPER, F2, exec, node ~/.config/quickshell/bar-switch.js dynamicglacier
  bind = SUPER, F3, exec, node ~/.config/quickshell/bar-switch.js toggle
`);
}
