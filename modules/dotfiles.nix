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
  };
}