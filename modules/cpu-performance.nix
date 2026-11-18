{ pkgs, ... }:

{
  # Use intel_pstate=active for hardware-managed P-states
  boot.kernelParams = [ "intel_pstate=active" ];

  boot.kernel.sysctl = {
    # Disable autogroup: improves compile/game throughput
    "kernel.sched_autogroup_enabled" = 0;
  };

  # power-profiles-daemon handles governor/EPP
  # Set default profile to "performance" at boot (instead of balanced)
  systemd.services.power-profile-performance = {
    description = "Set power profile to performance";
    after = [ "power-profiles-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
    };
  };
}