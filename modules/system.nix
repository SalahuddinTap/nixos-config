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
        # Fan control scripts — lets the rofi power menu switch fans without a password prompt
        { command = "/home/salahuddin/projects/cmds/fan.sh"; options = [ "NOPASSWD" ]; }
        { command = "/home/salahuddin/projects/cmds/fan-max.sh"; options = [ "NOPASSWD" ]; }
        { command = "/home/salahuddin/projects/cmds/fan-middle.sh"; options = [ "NOPASSWD" ]; }
        { command = "/home/salahuddin/projects/cmds/fan-silent.sh"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];
  # Flakes are the primary workflow; keep only the nixos-config lookup.
  # (The old nixpkgs entry pointed at root's channel — removed.)
  nix.nixPath = [ "nixos-config=/etc/nixos/configuration.nix" ];
  nixpkgs.config.allowUnfree = true;

  # Keep only the 10 newest system generations on every switch/boot, then gc
  # away the store paths the deleted generations referenced
  system.activationScripts.nixos-trim-generations = ''
    cd /nix/var/nix/profiles
    ls -1vd system-*-link | head -n -10 | xargs -r rm -f --
    ${pkgs.nix}/bin/nix-collect-garbage >/dev/null 2>&1 || true
  '';

  # Boot loader (systemd-boot EFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout = 5;

  # ZRAM swap
  zramSwap.enable = true;

  # Switchable CPU power profiles (power-saver / balanced / performance) via
  # `powerprofilesctl set <profile>` — driven from ~/projects/cmds/power-menu.sh.
  # thermald stays on as a safety net against overheating.
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;            # Intel thermal throttling control

  # Cap journald so logs don't grow unbounded on the NVMe
  services.journald.settings.Journal = {
    SystemMaxUse = "500M";
    SystemMaxFileSize = "50M";
  };

  # Timezone
  services.timesyncd.enable = true;
  # Automatically update timezone based on IP location
  services.automatic-timezoned.enable = true;

  # System state version (DO NOT CHANGE)
  system.stateVersion = "26.05";
  #file syncing
   services.syncthing = {
    enable = true;
    user = "salahuddin"; # Replace with your actual username
    dataDir = "/home/salahuddin"; # Where default configuration/files will live
    configDir = "/home/salahuddin/.config/syncthing"; 
    openDefaultPorts = true; # Opens necessary firewall ports (22000 and 21027)
  };
}
