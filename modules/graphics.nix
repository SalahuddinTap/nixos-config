{ config, pkgs, ... }:

{
  # CachyOS kernel (precompiled, optimized)
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # NVIDIA proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = pkgs.linuxPackages_cachyos.nvidiaPackages.stable;
  };

  # Chaotic NYX cache (prebuilt packages for cachyos)
  chaotic.nyx.cache.enable = true;
}