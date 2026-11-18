{ pkgs, ... }:

{
  # Register fish in /etc/shells so graphical sessions (SDDM/systemd) export
  # SHELL=fish instead of falling back to bash; without this, kitty and other
  # apps launched from Hyprland spawn bash even though the login shell is fish.
  environment.shells = with pkgs; [ bash bashInteractive fish ];

  users.users.salahuddin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "bluetooth" "docker" ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
}