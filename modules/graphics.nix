{ config, pkgs, ... }:

{
  # CachyOS kernel (precompiled, optimized)
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # NVIDIA proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ]; 

  # Enables the 32-bit graphics libraries Steam needs (fixes glXChooseVisual).
  programs.steam.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = pkgs.linuxPackages_cachyos.nvidiaPackages.stable;
  };
}