{ pkgs, ... }:

{
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = pkgs.linuxPackages_cachyos.nvidiaPackages.stable;

    # Kernel module parameters (require NVreg_ prefix)
    moduleParams = {
      nvidia = {
        # 1 = adaptive (not aggressive=3). On AC + gaming, wrap in power-profiles hook to set 0
        NVreg_DynamicPowerManagement = 1;
        # S0ix = deep GPU sleep on laptop (saves battery)
        NVreg_EnableS0ixPowerManagement = 1;
        # PCIe relaxed ordering = free throughput
        NVreg_EnablePCIERelaxedOrderingMode = 1;
        # Resizable BAR = map full VRAM to CPU (5-15% GPU uplift). Needs BIOS: Above 4G Decoding + Resizable BAR = ON
        NVreg_EnableResizableBar = 1;
        # Preserve VRAM across suspend
        NVreg_PreserveVideoMemoryAllocations = 1;
      };
    };
  };

  # Vulkan ICD priority
  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
    __GL_THREADED_OPTIMIZATIONS = "1";
  };
}