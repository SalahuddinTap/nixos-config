{ pkgs, ... }:

{
  home.username = "salahuddin";
  home.homeDirectory = "/home/salahuddin";

  home.packages = with pkgs; [
    fastfetch
    btop
    eza
    rofi
  ];

  programs.waybar.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ff = "fastfetch";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
    };
  };

  home.stateVersion = "26.11";
}
