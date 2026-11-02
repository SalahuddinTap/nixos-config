{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/graphics.nix
    ./modules/network.nix
    ./modules/audio.nix
    ./modules/desktop.nix
    ./modules/virtualisation.nix
    ./modules/users.nix
    ./modules/fan.nix
  ];

  # Auto-mount Arch partition
  fileSystems."/mnt/arch" = {
    device = "/dev/disk/by-uuid/f67c8a05-b726-4c07-beb0-42daf009ec9c";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  # Additional system packages (non-desktop)
  environment.systemPackages = with pkgs; [
    fish
    git
    yazi
    ghostty
    neovim
    vscode
    wget
    fastfetch
    spotify
    spicetify-cli
    brave               # Brave browser
    wl-clipboard        # wl-copy, wl-paste for Wayland clipboard
    cliphist            # Clipboard history manager (stores history, works with rofi)
    spotube              # Spotify replacement (open-source client)
    floorp-bin           # Firefox-based browser (Zen Browser alternative)
    # LSP servers (NixOS-native, work without patchelf)
    lua-language-server
    pyright
    typescript-language-server
    vscode-langservers-extracted  # json, css, html
    yaml-language-server
    bash-language-server
    nil                   # Nix LSP
  ];
}