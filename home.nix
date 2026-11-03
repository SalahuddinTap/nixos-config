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

  # fish is the only interactive shell (login shell set in users.nix).
  # bash remains only as /bin/sh for system scripts — no HM bash config.
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      ff = "fastfetch";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
      bar-island = "bar-switch.sh island";
      bar-wide = "bar-switch.sh wide";
    };
  };

  home.sessionVariables = {
    # ~/.local/bin must be on PATH (bar-switch.sh, kari-pip.sh, cliphist-rofi.sh, qmd)
    PATH = "$HOME/.local/bin:$PATH";
    # Qt5Compat QML import path for the dynamicglacier Quickshell bar
    # (nix-managed, no hardcoded store hashes)
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";
    NIXPKGS_QT6_QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";
  };

  home.stateVersion = "26.11";
}
