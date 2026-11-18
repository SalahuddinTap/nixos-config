{ pkgs, ... }:

{
  # Raw EC access for fan control on the MSI GF63 Thin 11UC.
  # The in-kernel msi-ec driver only whitelists EC fw 16R6EMS1.104; this machine
  # has 16R6EMS1.10E, so msi-ec never creates /sys/devices/platform/msi-ec.
  # ec_sys exposes raw EC memory at /sys/kernel/debug/ec/ec0/io instead.
  boot.kernelModules = [ "ec_sys" ];
  boot.extraModprobeConfig = ''
    options ec_sys write_support=1
  '';

  # Applies the fan profile stored in ~/.local/bin/boot/profile at boot.
  # Managed with: ~/.local/bin/boot/set-boot.sh {max|middle|silent|off|status}
  systemd.services.msi-fan-boot = {
    description = "Apply MSI fan profile at boot";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # systemd services have a minimal PATH on NixOS (no /usr/bin), so use
      # store paths explicitly and give the script its runtime tools.
      ExecStart = "${pkgs.bash}/bin/bash /home/salahuddin/.local/bin/boot/apply-boot-profile.sh";
      Path = [
        "${pkgs.bash}/bin"
        "${pkgs.coreutils}/bin"
        "${pkgs.kmod}/bin"
      ];
    };
  };
}
