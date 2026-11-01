{ config, pkgs, ... }:

{
  users.users.salahuddin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "bluetooth" ];
  };
}