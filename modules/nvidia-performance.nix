{ pkgs, lib, ... }:

{
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = pkgs.linuxPackages_cachyos.nvidiaPackages.stable;

    # PRIME render offload: iGPU drives display, dGPU for games via prime-run
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus IDs from lspci: Intel 00:02.0, NVIDIA 01:00.0
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Fine-grained power management for runtime PM
    powerManagement = {
      finegrained = true;
    };

    # Kernel module parameters (require NVreg_ prefix)
    moduleParams = {
      nvidia = {
        # 1 = adaptive (not aggressive=3). On AC + gaming, wrap in power-profiles hook to set 0
        NVreg_DynamicPowerManagement = lib.mkForce 1;
        # S0ix = deep GPU sleep on laptop (saves battery)
        NVreg_EnableS0ixPowerManagement = lib.mkForce 1;
        # PCIe relaxed ordering = free throughput
        NVreg_EnablePCIERelaxedOrderingMode = lib.mkForce 1;
        # Resizable BAR = map full VRAM to CPU (5-15% GPU uplift). Needs BIOS: Above 4G Decoding + Resizable BAR = ON
        NVreg_EnableResizableBar = lib.mkForce 1;
        # Preserve VRAM across suspend
        NVreg_PreserveVideoMemoryAllocations = lib.mkForce 1;
      };
    };
  };
}