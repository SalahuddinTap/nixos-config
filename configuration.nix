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

  # Allow prebuilt dynamically-linked Linux binaries (Mason lua-language-server,
  # codelldb adapter, Copilot language server) to run on NixOS
  programs.nix-ld.enable = true;

  # Additional system packages (non-desktop)
  environment.systemPackages = with pkgs; [
    fish
    git
    yazi
    quickshell
    neovim
    vscode
    wget
    fastfetch
    spotify
    spicetify-cli
    brave               # Brave browser (Zen is a flatpak: flatpak run app.zen_browser.zen)
    wl-clipboard        # wl-copy, wl-paste for Wayland clipboard
    cliphist            # Clipboard history manager (stores history, works with rofi)
    mpv                  # Video player (for kari PiP)
    gcc
    fd
    ripgrep
    tree-sitter
    unzip
    luarocks
    jq                   # For kari-pip script JSON parsing
  ];
}
