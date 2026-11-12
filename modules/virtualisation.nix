{ config, pkgs, ... }:

{
  # Flatpak support
  services.flatpak.enable = true;
  # Enable user namespaces for flatpak sandboxing
  boot.kernel.sysctl."user.max_user_namespaces" = 10000;

  # Bubblewrap (for flatpak sandboxing)
  environment.systemPackages = with pkgs; [ bubblewrap ];

  # Docker: daemon available but not started at boot (start on demand with
  # `systemctl start docker`) — removes it from the boot critical chain
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    package = pkgs.docker;
  };
}