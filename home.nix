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
    tree-sitter
  ];

  programs.waybar.enable = true;
  programs.fish.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ff = "fastfetch";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
      bar-pill = "pkill -9 quickshell 2>/dev/null; sleep 0.5; QS_ACTIVE_BAR=hyprminimal /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell >/dev/null 2>&1 &";
      bar-island = "pkill -9 quickshell 2>/dev/null; sleep 0.5; QS_ACTIVE_BAR=dynamicglacier /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell >/dev/null 2>&1 &";
      bar-wide = "pkill -9 quickshell 2>/dev/null; sleep 0.5; QS_ACTIVE_BAR=anomshell /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell >/dev/null 2>&1 &";
      bar-me = "pkill -9 quickshell 2>/dev/null; sleep 0.5; QS_ACTIVE_BAR=bar-me /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell >/dev/null 2>&1 &";
      bar-mines = "pkill -9 quickshell 2>/dev/null; sleep 0.5; QS_ACTIVE_BAR=bar-mines /nix/store/bbxmzvqnyssi0y1sq3iqdakm8y09mdga-quickshell-wrapped-0.3.2/bin/quickshell -c /home/salahuddin/.config/quickshell >/dev/null 2>&1 &";
    };
  };

  home.stateVersion = "26.11";
}
