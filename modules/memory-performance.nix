{ ... }:

{
  # ZRAM: ~9 GiB (30% of 32 GiB); zstd
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
  zramSwap.memoryMax = 9663676416;  # 9 GiB in bytes

  boot.kernelParams = [ "transparent_hugepage=madvise" ];
  boot.kernel.sysctl = {
    # Swappiness 80 = swap before RAM pressure, but don't thrash (was 100)
    "vm.swappiness" = 80;
    # Reclaim pagecache less aggressively (keep hot code in RAM)
    "vm.vfs_cache_pressure" = 50;
    # Writeback: bigger batches, less often = fewer IO stalls
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 15;
    "vm.dirty_expire_centisecs" = 6000;
    "vm.dirty_writeback_centisecs" = 1500;
  };
}