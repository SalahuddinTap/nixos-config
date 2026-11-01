{ config, pkgs, ... }:

{
  # Flatpak support
  services.flatpak.enable = true;
  # Enable user namespaces for flatpak sandboxing
  boot.kernel.sysctl."user.max_user_namespaces" = 10000;

  # Bubblewrap (for flatpak sandboxing)
  environment.systemPackages = with pkgs; [ bubblewrap ];

  # Docker
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker;
  };
}