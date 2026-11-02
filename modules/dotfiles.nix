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

    ".config/ghostty/config.ghostty" = {
      source = ./config/ghostty/config;
      force = true;
    };

    # Quickshell — recursive copy of entire directory tree
    ".config/quickshell" = {
      source = ./config/quickshell;
      recursive = true;
      force = true;
    };

    ".config/waybar/config.jsonc" = {
      source = ./config/waybar/config.jsonc;
      force = true;
    };

    ".config/waybar/style.css" = {
      source = ./config/waybar/style.css;
      force = true;
    };

    ".config/spicetify/config-xpui.ini" = {
      source = ./config/spicetify/config-xpui.ini;
      force = true;
    };

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

    # Qt5Compat for dynamicglacier bar
    ".config/environment.d/20-qt5compat.conf" = {
      source = ./config/environment.d/20-qt5compat.conf;
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

    # Rofi theme (Vanta Black)
    ".config/rofi/theme.rasi" = {
      source = ./config/rofi/theme.rasi;
      force = true;
    };

    # Neovim config (Vanta Black)
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
      force = true;
    };
  };
}