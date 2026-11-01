{ config, pkgs, ... }:

{
  # PipeWire (required by Hyprland) with Bluetooth support
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}