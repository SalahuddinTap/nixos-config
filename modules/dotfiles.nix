{ config, pkgs, ... }:

{
  # Home-manager dotfiles — symlinks configs from this repo into ~/.config
  # Edit files in modules/config/ then run: sudo nixos-rebuild switch --flake .#nixos

  home.file = {
    ".config/hypr/hyprland.lua" = {
      source = ./config/hypr/hyprland.lua;
    };

    ".config/hypr/hyprpaper.conf" = {
      source = ./config/hypr/hyprpaper.conf;
    };

    ".config/kitty/kitty.conf" = {
      source = ./config/kitty/kitty.conf;
    };

    # Quickshell — recursive copy of entire directory tree
    ".config/quickshell" = {
      source = ./config/quickshell;
      recursive = true;
    };

    ".config/waybar/config.jsonc" = {
      source = ./config/waybar/config.jsonc;
    };

    ".config/waybar/style.css" = {
      source = ./config/waybar/style.css;
    };

    ".config/spicetify/config-xpui.ini" = {
      source = ./config/spicetify/config-xpui.ini;
    };

    ".config/dolphinrc" = {
      source = ./config/dolphinrc;
    };

    ".config/mimeapps.list" = {
      source = ./config/mimeapps.list;
    };
  };
}