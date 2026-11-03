# NixOS + Home-Manager config

`/etc/nixos` is a symlink to this repo. Apply changes:

```bash
rebuild          # = sudo nixos-rebuild switch --flake .#nixos
```

## Layout

- `configuration.nix` / `home.nix` — system + home-manager entry points
- `modules/*.nix` — system modules (desktop, audio, graphics, …)
- `modules/config/` — dotfiles deployed into `~/.config` via `modules/dotfiles.nix`
  - `quickshell/` — Quickshell shell. Two bars: **island** (`dynamicglacier`) and **wide** (`anomshell`)
  - `hypr/`, `kitty/`, `rofi/`, `nvim/`, `scripts/`

## Bar switching (single mechanism)

```bash
bar-island    # or: bar-switch.sh island   -> dynamicglacier
bar-wide      # or: bar-switch.sh wide     -> anomshell
```

Implemented by `~/.local/bin/bar-switch.sh`, which sets `QS_ACTIVE_BAR` and
launches `quickshell` from PATH (no hardcoded /nix/store paths).

## Conventions

- Never hardcode `/nix/store/...` paths in configs/scripts — use PATH or
  `home.sessionVariables` with `pkgs.*` references.
- All user configs live in this repo and are deployed by home-manager;
  edit here, then `rebuild`.

## Keybinds (Hyprland)

SUPER+Q close · SUPER+T kitty · SUPER+B brave · SUPER+Z zen · SUPER+E dolphin ·
SUPER+R rofi · SUPER+V float · SUPER+P kari PiP (mpv) · SUPER+SHIFT+V clipboard
