{ config, pkgs, ... }:

{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.nixPath = [ "nixos-config=/etc/nixos/configuration.nix" "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos" ];
  nixpkgs.config.allowUnfree = true;

  # Boot loader (systemd-boot EFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout = 5;

  # ZRAM swap
  zramSwap.enable = true;

  # Timezone
  services.timesyncd.enable = true;
  # Automatically update timezone based on IP location
  services.automatic-timezoned.enable = true;

  # System state version (DO NOT CHANGE)
  system.stateVersion = "26.05";
}
