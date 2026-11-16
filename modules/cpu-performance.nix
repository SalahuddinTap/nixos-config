{ config, pkgs, ... }:

{
  # Use intel_pstate=active for hardware-managed P-states
  boot.kernelParams = [ "intel_pstate=active" ];

  boot.kernel.sysctl = {
    # Disable autogroup: improves compile/game throughput
    "kernel.sched_autogroup_enabled" = 0;
  };

  # power-profiles-daemon handles governor/EPP (default: balanced)
  # No cpu-governor service - let PPD manage it
}