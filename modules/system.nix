{ config, pkgs, ... }:

{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Passwordless sudo for the agent/rebuild commands pi runs — after one final
  # `sudo nixos-rebuild switch`, these never prompt again.
  security.sudo.extraRules = [
    {
      users = [ "salahuddin" ];
      commands = [
        { command = "/run/current-system/sw/bin/nixos-rebuild"; options = [ "NOPASSWD" ]; }
        { command = "/nix/var/nix/profiles/default/bin/nixos-rebuild"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nix"; options = [ "NOPASSWD" ]; }
        { command = "/nix/var/nix/profiles/default/bin/nix"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/home-manager"; options = [ "NOPASSWD" ]; }
        { command = "/nix/var/nix/profiles/default/bin/home-manager"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/switch-to-configuration"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];
  # Flakes are the primary workflow; keep only the nixos-config lookup.
  # (The old nixpkgs entry pointed at root's channel — removed.)
  nix.nixPath = [ "nixos-config=/etc/nixos/configuration.nix" ];
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
