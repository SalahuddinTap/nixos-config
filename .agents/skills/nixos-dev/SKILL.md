---
name: nixos-dev
description: Use when working in ~/projects/nixos-config (the NixOS flake: configuration.nix, home.nix, modules/*.nix, modules/config/{hypr,quickshell,rofi,kitty,...}). Covers the edit → rebuild → verify workflow, home-manager dotfile management, and desktop shell (Hyprland/Quickshell) work. Also applies to any nix expression editing.
---

# NixOS config workflow

## Files
- `flake.nix` / `flake.lock` — inputs (nixpkgs, home-manager, spicetify-nix, ...)
- `configuration.nix`, `hardware-configuration.nix`
- `home.nix` — home-manager (fish, programs, dotfiles)
- `modules/*.nix` — system modules; `modules/config/` — raw dotfiles (hypr/hyprland.lua, quickshell bars, rofi, kitty, scripts)

## Workflow
1. Edit nix files. **Never** edit `~/.config/...` directly — those are home-manager symlinks into the store; edit the source in `modules/config/`.
2. Rebuild: `sudo nixos-rebuild switch --flake .#nixos` (or `home-manager switch --flake .#nixos` for HM-only changes — check flake outputs).
3. Verify live: `hyprctl reload`, check the quickshell bar layer (`hyprctl layers`), `fish -lc 'echo $PATH'`, etc.
4. Commit to the nixos-config repo after verification.

## Look things up instead of guessing
- Use the `nixos` MCP server (global, lazy): `nix` tool searches 130k packages / 23k NixOS options / Home Manager options — use it before adding any new option or package.
- `@firstpick/pi-extension-nixos-wiki-local` / hyprland / quickshell wiki-local extensions provide offline docs if the MCP is slow.
- `quickshell-design` skill for bar/QML work; matugen-based OLED theming lives in modules/config — keep theme generation scripts intact.

## Gotchas learned (from MEMORY.md)
- fish is the only interactive shell; test login env with `env -i HOME=$HOME fish -lic ...` not plain `fish -lc` (HM session vars).
- Hyprland binds verified via `hyprctl reload` + `hyprctl binds`.
