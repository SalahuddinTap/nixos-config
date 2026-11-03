{ config, pkgs, ... }:

{
  # Home-manager dotfiles — symlinks configs from this repo into ~/.config
  # Edit files in modules/config/ then run: sudo nixos-rebuild switch --flake .#nixos

  home.file = {
    ".config/hypr/hyprland.lua" = {
      source = ./config/hypr/hyprland.lua;
      force = true;
    };

    ".config/hypr/hyprpaper.conf" = {
      source = ./config/hypr/hyprpaper.conf;
      force = true;
    };

    ".config/kitty/kitty.conf" = {
      source = ./config/kitty/kitty.conf;
      force = true;
    };

    # Quickshell — recursive copy of entire directory tree
    ".config/quickshell" = {
      source = ./config/quickshell;
      recursive = true;
      force = true;
    };

    # Neovim (LazyVim) — recursive
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
      force = true;
    };

    # NOTE: ~/.config/spicetify/config-xpui.ini is now managed by
    # spicetify-nix (home.nix programs.spicetify) — no HM dotfile entry.

    ".config/dolphinrc" = {
      source = ./config/dolphinrc;
      force = true;
    };

    ".config/mimeapps.list" = {
      source = ./config/mimeapps.list;
      force = true;
    };

    # Nerd Font (JetBrains Mono) for icon glyphs
    ".config/fontconfig/conf.d/10-nerdfonts.conf" = {
      source = ./config/fontconfig/nerdfonts.conf;
      force = true;
    };

    # Clipboard history rofi script
    ".local/bin/cliphist-rofi.sh" = {
      source = ./config/scripts/cliphist-rofi.sh;
      force = true;
    };

    # kari PiP — Super+P toggle (float + pin corner for mpv)
    ".local/bin/kari-pip.sh" = {
      source = ./config/scripts/kari-pip.sh;
      executable = true;
      force = true;
    };

    # Rofi config + theme (Vanta Black)
    ".config/rofi/config.rasi" = {
      source = ./config/rofi/config.rasi;
      force = true;
    };

    ".config/rofi/theme.rasi" = {
      source = ./config/rofi/theme.rasi;
      force = true;
    };

    # Bar switcher (single mechanism: QS_ACTIVE_BAR env, quickshell from PATH)
    ".local/bin/bar-switch.sh" = {
      source = ./config/scripts/bar-switch.sh;
      executable = true;
      force = true;
    };

    # Fan control + PC mount helpers
    ".local/bin/fan" = {
      source = ./config/scripts/fan;
      executable = true;
      force = true;
    };

    ".local/bin/pc-mount" = {
      source = ./config/scripts/pc-mount;
      executable = true;
      force = true;
    };

  };
}