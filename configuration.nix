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

  # Additional system packages (non-desktop)
  environment.systemPackages = with pkgs; [
    git
    vscode
    wget
    fastfetch
    spicetify-cli
  ];
}