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

  # Firewall: enabled by default (networking.firewall.enable = true is default)
  # Allowed ports for Syncthing (opened via services.syncthing.openDefaultPorts):
  # TCP 22000, UDP 21027/22000

  # Early OOM killer
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;      # percent
    freeSwapThreshold = 10;     # percent
    reportInterval = 3600;      # seconds
  };
}
