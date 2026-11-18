# NixOS + Home-Manager config

`/etc/nixos` is a symlink to this repo. Apply changes:

```bash
rebuild          # = sudo nixos-rebuild switch --flake .#nixos
```

## Layout

- `configuration.nix` / `home.nix` — system + home-manager entry points
- `modules/*.nix` — system modules (desktop, audio, graphics, …)
- `modules/config/` — dotfiles deployed into `~/.config` via `modules/dotfiles.nix`
  - `quickshell/` — Quickshell shell, autostarted from `hypr/hyprland.lua`.
    Bars: **island** (`modules/dynamicGlacier`, default), **wide** (`bars/widebar`),
    **widebar2** (`bars/widebar2`)
  - `hypr/`, `kitty/`, `rofi/`, `nvim/`, `scripts/` (fan/power scripts → `~/.local/bin`)

## Bar switching (single mechanism)

```bash
bar-island    # or: bar-switch.sh island     -> dynamicglacier
bar-wide      # or: bar-switch.sh wide       -> widebar
bar-switch    # rofi menu: island / widebar / widebar2
```

Implemented by `~/.local/bin/bar-switch.sh`, which sets `QS_ACTIVE_BAR` and
launches `quickshell` from PATH (no hardcoded /nix/store paths).

## Conventions

- Never hardcode `/nix/store/...` paths in configs/scripts — use PATH or
  `home.sessionVariables` with `pkgs.*` references.
- All user configs live in this repo and are deployed by home-manager;
  edit here, then `rebuild`.

## Keybinds (Hyprland)

SUPER+Q close · SUPER+T kitty · SUPER+B / SUPER+Z zen (flatpak) · SUPER+E dolphin ·
SUPER+R rofi · SUPER+V float · SUPER+P kari PiP (mpv) · SUPER+SHIFT+V clipboard

## Restoring from scratch

1. Boot the NixOS installer ISO on the new machine, install NixOS (minimal),
   and set a login password: `passwd salahuddin`. **No password hash is in
   this repo** — set one manually, or adopt sops-nix/agenix and add
   `users.users.salahuddin.hashedPassword` from a secrets file.
2. Clone the private remote and link it:
   `git clone <private-url> ~/projects/nixos-config && sudo ln -s ~/projects/nixos-config /etc/nixos`
3. Regenerate host-specific hardware config (disk UUIDs, /boot UUID, CPU
   microcode are machine-specific):
   `sudo nixos-generate-config --root /mnt` (during install) or after boot,
   then copy the generated `hardware-configuration.nix` over the repo's.
   On non-NVIDIA / non-MSI-GF63 hardware also review `modules/graphics.nix`,
   `modules/nvidia-performance.nix`, `modules/fan.nix`, `modules/battery.nix`,
   and the `eDP-1` monitor line in `modules/config/hypr/hyprland.lua`.
4. Secrets: **none live in this repo** (a stray `data/rsa_key.pem` was purged
   from history — treat that key as compromised and rotate it). Re-create
   SSH keys (`ssh-keygen`), `gh auth login`, Bitwarden, etc. manually.
   Wi-Fi PSKs are stored by NetworkManager on the machine, not here.
5. Build first, switch second:
   `sudo nixos-rebuild build --flake .#nixos`   # evaluate/build only
   `sudo nixos-rebuild switch --flake .#nixos`  # apply (home-manager is wired in via flake.nix)
6. Install the flatpaks (imperative — one-shot script from the repo):
   `~/.local/bin/install-flatpaks.sh`
   (Zen/Sober/Vinegar system-wide, Stremio user-level.)
   Then grant Sober's sandbox access to the NVIDIA driver (once per machine):
   `flatpak override --user --filesystem=/run/opengl-driver:ro --filesystem=/run/opengl-driver-32:ro --filesystem=/nix/store:ro org.vinegarhq.Sober`
   Launch Roblox via `sober-nvidia` (NOT plain `flatpak run`) so the game uses
   the dGPU — it sets the Vulkan ICD and drops the `libvulkan.so` alias into
   the sandbox (without it the game silently falls back to the Intel iGPU).
7. Log in. Quickshell autostarts from the repo config via hyprland
   (`hyprland.start`); switch bars with `bar-island` / `bar-wide` /
   `bar-tripathi` or the rofi menu: `bar-switch.sh` (no args). Bars:
   island = dynamicGlacier, widebar, widebar2, tripathi (own config in
   `~/.config/quickshell-tripathi`).
   Set the boot fan profile: `sudo ~/.local/bin/boot/set-boot.sh silent`
   (manual control: `fan`, `fan-max.sh`, `fan-middle.sh`, `fan-silent.sh`,
   all in `~/.local/bin`, passwordless via sudoers).
8. Sanity check: `nix flake check`, `systemctl --user status`,
   `systemctl status keyd` (should be active — keymap ships in repo now).
