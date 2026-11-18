{ pkgs, ... }:

{
  # Flatpak support
  services.flatpak.enable = true;
  # Apps installed via flatpak (restored automatically on rebuild).
  # NOTE: Stremio was installed --user on the original machine; declared
  # system-wide here so a fresh restore gets everything from the repo.
  services.flatpak.packages = [
    { appId = "app.zen_browser.zen"; origin = "flathub"; }
    { appId = "org.vinegarhq.Vinegar"; origin = "flathub"; }
    { appId = "org.vinegarhq.Sober"; origin = "flathub"; }
    { appId = "com.stremio.Stremio"; origin = "flathub"; }
  ];
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