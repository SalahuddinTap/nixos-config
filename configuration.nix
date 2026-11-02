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
    git
    yazi
    ghostty
    vscode
    wget
    fastfetch
    spotify
    spicetify-cli
  ];
}
