{ pkgs, ... }:

{
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1h";
    configs = {
      # Root keeps at most 10 snapshots total: 5 rebuild ("number") + 5 hourly
      # ("timeline").  Snapper counts the two algorithms separately.
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 0;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
        NUMBER_CLEANUP = true;
        NUMBER_LIMIT = 5;
        NUMBER_LIMIT_IMPORTANT = 1;
        # Allow pruning right away instead of waiting an hour for age
        NUMBER_MIN_AGE = 0;
      };
      # Home only has hourly snapshots, so it spends the whole budget there.
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 0;
        TIMELINE_LIMIT_WEEKLY = 0;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
        # Manual snapshots (no cleanup algorithm) are never touched
        NUMBER_CLEANUP = false;
      };
    };
  };

  # 1. Automatically check and scrub Btrfs partitions for bit rot weekly
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" "/home" ];
  };

  # 2. Automatically create a root snapshot right before every nixos-rebuild switch.
  #    --cleanup number is required: without a cleanup algorithm the snapshot is
  #    ignored by every cleanup algorithm and accumulates forever.
  system.activationScripts.snapper-pre-switch = ''
    ${pkgs.snapper}/bin/snapper -c root create --cleanup number --description "Pre-switch backup $(date +%F_%T)" || true
  '';
}
