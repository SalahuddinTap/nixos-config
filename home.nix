{ pkgs, ... }:

{
  imports = [
    ./modules/dotfiles.nix
  ];

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
      bar-pill = "echo 'hyprminimal' > /tmp/quickshell-active-bar && pkill quickshell 2>/dev/null; sleep 0.5; /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell &";
      bar-island = "echo 'dynamicglacier' > /tmp/quickshell-active-bar && pkill quickshell 2>/dev/null; sleep 0.5; /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell &";
      bar-wide = "echo 'anomshell' > /tmp/quickshell-active-bar && pkill quickshell 2>/dev/null; sleep 0.5; /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell &";
    };
  };

  home.stateVersion = "26.11";
}