{ config, pkgs, ... }:

{
  # Hyprland Wayland compositor
  programs.hyprland.enable = true;

  # Display manager (SDDM with Wayland) for Hyprland login
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # XDG desktop portal for Wayland apps (file pickers, screen sharing, etc.)
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;

  # Icon font used by the quickshell island bar (Material Symbols Rounded ligatures)
  fonts.packages = with pkgs; [
    material-symbols
  ];
  
  services.upower.enable = true;
  
  # Desktop packages
  environment.systemPackages = with pkgs; [
    pi-coding-agent
    kdePackages.dolphin
    rofi
    kitty
    hyprlock
    hyprpaper
    ncpamixer
    hyprsunset
    networkmanagerapplet
    pwvucontrol
    overskride
    hyprshot
    nerd-fonts.jetbrains-mono
  ];
}
