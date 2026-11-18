{ pkgs, ... }:

{
  # keyd: system-wide keyboard remapping daemon.
  # Keymaps go in services.keyd.keyboards (e.g. /etc/keyd/default.conf equivalents).
  services.keyd.enable = true;

  # ratbagd: D-Bus daemon that piper talks to for gaming mice (DPI, buttons, profiles, LEDs)
  services.ratbagd.enable = true;

  # piper: GTK GUI for gaming mouse settings on top of libratbag
  environment.systemPackages = with pkgs; [
    piper
  ];
}
