{ pkgs, ... }:

{
  # Battery charge limit (end threshold only) for MSI GF63
  # Sets charge_control_end_threshold = 80 to preserve battery health
  # when on AC power (90% of time). Does NOT touch start threshold.
  systemd.services.battery-charge-limit = {
    description = "Set battery charge end threshold to 80%";
    documentation = [ "man:systemd.service(5)" ];
    after = [ "systemd-modules-load.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Retry until the sysfs file appears (msi_ec may load late)
      ExecStartPre = ''
        ${pkgs.bash}/bin/bash -c '
          for i in {1..30}; do
            [[ -f /sys/class/power_supply/BAT1/charge_control_end_threshold ]] && exit 0
            sleep 0.2
          done
          echo "BAT1 charge_control_end_threshold not found" >&2
          exit 1
        '
      '';
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold'";
    };
  };

  # Re-apply on resume from suspend (systemd sleep hook)
  systemd.services.battery-charge-limit-resume = {
    description = "Re-apply battery charge limit after suspend";
    after = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold'";
    };
  };
}