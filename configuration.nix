{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/graphics.nix
    ./modules/network.nix
    ./modules/audio.nix
    ./modules/desktop.nix
    ./modules/input-devices.nix
    ./modules/virtualisation.nix
    ./modules/users.nix
    ./modules/fan.nix
    ./modules/snapper.nix
    ./modules/hyprlock.nix
    ./modules/battery.nix
    # Performance modules
    ./modules/cpu-performance.nix
    ./modules/memory-performance.nix
    ./modules/storage-performance.nix
    ./modules/nvidia-performance.nix
    ./modules/network-performance.nix
    # NOTE: modules/pi-packages.nix is staged but NOT imported — import it only
    # when activating nix-managed pi packages (see the file header).
  ];

  # Allow prebuilt dynamically-linked Linux binaries (Mason lua-language-server,
  # codelldb adapter, Copilot language server) to run on NixOS
  programs.nix-ld.enable = true;

  # Additional system packages (non-desktop)
  environment.systemPackages = with pkgs; [
    gnome-control-center
    glibc.dev
    glibc
  ];
}
