{ config, pkgs, ... }:

{
  # Use "performance" governor on intel_pstate=active = hardware ramps to max turbo instantly
  boot.kernelParams = [ "intel_pstate=active" ];

  boot.kernel.sysctl = {
    # Disable autogroup: improves compile/game throughput
    "kernel.sched_autogroup_enabled" = 0;
  };

  # Apply at boot: set governor + force min_perf_pct=100 (overrides power-profiles-daemon)
  systemd.services.cpu-governor = {
    description = "Set CPU governor to performance and min_perf_pct=100";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'for c in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > $c; done; echo 100 > /sys/devices/system/cpu/intel_pstate/min_perf_pct'";
    };
  };
}