{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  # Don't block boot/login on network being online (was costing ~22s of boot time):
  # detach NetworkManager-wait-online from network-online.target so it never runs
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
  # Wi-Fi power saving off — max performance mode
  networking.networkmanager.wifi.powersave = false;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Firewall (currently disabled - uncomment to enable)
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}
