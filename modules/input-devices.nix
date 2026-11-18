{ pkgs, ... }:

{
  # keyd: system-wide keyboard remapping daemon.
  # Without a keymap file keyd exits 255 (start-limit) — ship a minimal
  # no-op default; add real remaps under [main] below.
  services.keyd.enable = true;
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
  '';

  # ratbagd: D-Bus daemon that piper talks to for gaming mice (DPI, buttons, profiles, LEDs)
  services.ratbagd.enable = true;

  # piper: GTK GUI for gaming mouse settings on top of libratbag
  environment.systemPackages = with pkgs; [
    piper
  ];
}
