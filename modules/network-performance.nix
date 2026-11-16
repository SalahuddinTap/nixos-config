{ config, pkgs, ... }:

{
  boot.kernel.sysctl = {
    # BBR = higher throughput, lower RTT under loss (Linux 6.0+)
    "net.ipv4.tcp_congestion_control" = "bbr";
    # Buffer autotuning for modern links
    "net.ipv4.tcp_rmem" = "8192 262144 33554432";
    "net.ipv4.tcp_wmem" = "8192 262144 33554432";
    "net.core.rmem_max" = 33554432;
    "net.core.wmem_max" = 33554432;
    # Reduce queuing latency
    "net.core.netdev_max_backlog" = 5000;
    "net.core.netdev_budget" = 1000;
    # Fastopen
    "net.ipv4.tcp_fastopen" = 3;
    # Disable slow-start-after-idle (hurts bursty workloads)
    "net.ipv4.tcp_slow_start_after_idle" = 0;
  };

  # Wi-Fi powersave already off in network.nix
}