{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./modules/dotfiles.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "salahuddin";
  home.homeDirectory = "/home/salahuddin";

  home.packages = with pkgs; [
    discord
    vesktop
    fish
    git
    gh
    curl
    nano
    yazi
    quickshell
    neovim
    wget
    fastfetch
    rust-analyzer
    cargo
    rustc
    wl-clipboard
    cliphist
    mpv
    gcc
    fd
    ripgrep
    protonmail-desktop
    tree-sitter
    microsoft-edge
    librewolf-bin-unwrapped
    unzip
    luarocks
    jq
    gnumake
    nodejs
    dust
    cudatoolkit
    linuxPackages_cachyos.nvidiaPackages.stable
    lazygit
    zed-editor
    nixd
    nil
    btop
    eza
    rofi
    tmux
    bat
    appimage-run
    steam-run
    grim
    slurp
    wf-recorder
    brightnessctl
    playerctl
    wlogout
    libnotify
    # Add Claude Desktop from the flake input's packages for your system architecture:
    # Wrapper to force Electron X11 backend (fixes Wayland+NVIDIA crash)
    (pkgs.writeShellScriptBin "claude-desktop" ''
      exec ${inputs.claude-desktop-nix-flake.packages.${pkgs.system}.default}/bin/claude-desktop \
        --ozone-platform=x11 \
        --enable-features=UseOzonePlatform \
        "$@"
    '')
  ];

  # fish is the only interactive shell (login shell set in users.nix).
  # bash remains only as /bin/sh for system scripts — no HM bash config.
  # Fish-specific environment initialization
  # NVML (GPU monitoring) + CUDA paths — the nvidia driver provides
  # libnvidia-ml.so at runtime via /run/opengl-driver/lib on NixOS.
  programs.fish.shellInit = ''
    set -gx C_INCLUDE_PATH "${pkgs.linuxPackages_cachyos.nvidiaPackages.stable}/include" "${pkgs.cudatoolkit}/include" $C_INCLUDE_PATH
    set -gx LIBRARY_PATH "/run/opengl/driver/lib" "${pkgs.cudatoolkit}/lib" $LIBRARY_PATH
    set -gx LD_LIBRARY_PATH "/run/opengl/driver/lib" $LD_LIBRARY_PATH
  '' ;
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      ff = "fastfetch";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
      rebuild-update = "cd ~/projects/nixos-config && nix flake update && sudo nixos-rebuild switch --flake .#nixos && sudo nix-collect-garbage --delete-older-than 7d && nix-store --optimise";
      bar-island = "bar-switch.sh island";
      bar-wide = "bar-switch.sh widebar";
      bar-tripathi = "bar-switch.sh tripathi";
    };
  };

  # Declarative Spicetify (spicetify-nix): theme and extensions applied on rebuild
  programs.spicetify = {
    enable = true;
    enabledExtensions = [ spicePkgs.extensions.adblockify ];
    # Sleek with the VantaBlack color scheme
    theme = spicePkgs.themes.sleek;
    colorScheme = "VantaBlack";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    # Electron apps (Vesktop/Discord) run on Wayland instead of XWayland
    NIXOS_OZONE_WL = "1";
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";
    NIXPKGS_QT6_QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml";
    # CUDA + NVML paths for compiling GPU programs (temp-converter etc.)
    C_INCLUDE_PATH = "${pkgs.linuxPackages_cachyos.nvidiaPackages.stable}/include:${pkgs.cudatoolkit}/include";
    LIBRARY_PATH = "/run/opengl/driver/lib:${pkgs.cudatoolkit}/lib";
    LD_LIBRARY_PATH = "/run/opengl/driver/lib";
  };

  # Keep in sync with system.stateVersion (modules/system.nix)
  home.stateVersion = "26.05";
}