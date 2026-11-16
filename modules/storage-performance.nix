{ config, pkgs, ... }:

{
  # Override mount options from hardware-configuration.nix
  # compress=zstd:3 = sweet spot speed/ratio; commit=120 = less journal flushes; noatime = no timestamp writes
  fileSystems."/".options = [ "noatime" "ssd" "discard=async" "space_cache=v2" "compress=zstd:3" "commit=120" ];
  fileSystems."/home".options = [ "noatime" "ssd" "discard=async" "space_cache=v2" "compress=zstd:3" "commit=120" ];
  fileSystems."/nix".options  = [ "noatime" "ssd" "discard=async" "space_cache=v2" "compress=zstd:1" "commit=120" ];
}