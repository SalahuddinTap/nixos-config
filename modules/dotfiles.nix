{ ... }:

{
  # Home-manager dotfiles — symlinks configs from this repo into ~/.config
  # Edit files in modules/config/ then run: sudo nixos-rebuild switch --flake .#nixos

  home.file = {
    ".config/hypr/hyprland.lua" = {
      source = ./config/hypr/hyprland.lua;
      force = true;
    };

    ".config/hypr/hyprpaper.conf" = {
      source = ./config/hypr/hyprpaper.conf;
      force = true;
    };

    ".config/kitty/kitty.conf" = {
      source = ./config/kitty/kitty.conf;
      force = true;
    };

    ".config/starship.toml" = {
      source = ./config/starship.toml;
      force = true;
    };

    # Quickshell — recursive copy of entire directory tree
    ".config/quickshell" = {
      source = ./config/quickshell;
      recursive = true;
      force = true;
    };

    # Quickshell tripathi bar variant (switch with: bar-switch.sh tripathi)
    ".config/quickshell-tripathi" = {
      source = ./config/quickshell-tripathi;
      recursive = true;
      force = true;
    };

    # Neovim (LazyVim) — recursive
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
      force = true;
    };

    # NOTE: ~/.config/spicetify/config-xpui.ini is now managed by
    # spicetify-nix (home.nix programs.spicetify) — no HM dotfile entry.

    ".config/dolphinrc" = {
      source = ./config/dolphinrc;
      force = true;
    };

    # Hand-managed configs captured into the repo
    ".gitconfig" = {
      source = ./config/gitconfig;
      force = true;
    };
    ".ncpamixer.conf" = {
      source = ./config/ncpamixer.conf;
      force = true;
    };
    ".backup_exclude" = {
      source = ./config/backup_exclude;
      force = true;
    };
    # Hyprland's own mimeapps list — this one overrides ~/.config/mimeapps.list
    # for Hyprland-launched apps, so the default browser must be set here too
    ".config/hyprland-mimeapps.list" = {
      source = ./config/hyprland-mimeapps.list;
      force = true;
    };
    "backup_projects.sh" = {
      source = ./config/scripts/backup_projects.sh;
      executable = true;
      force = true;
    };
    ".local/bin/install-flatpaks.sh" = {
      source = ./config/scripts/install-flatpaks.sh;
      executable = true;
      force = true;
    };
    ".config/fish/conf.d/npm-global.fish" = {
      source = ./config/fish/conf.d/npm-global.fish;
      force = true;
    };
    ".config/hypr/sound/eq.conf" = {
      source = ./config/hypr/sound/eq.conf;
      force = true;
    };
    ".config/rofi/bar-menu.rasi" = {
      source = ./config/rofi/bar-menu.rasi;
      force = true;
    };
    ".config/wireplumber/wireplumber.conf.d/51-bluez-a2dp-only.conf" = {
      source = ./config/wireplumber/wireplumber.conf.d/51-bluez-a2dp-only.conf;
      force = true;
    };
    ".config/qmd/index.yml" = {
      source = ./config/qmd/index.yml;
      force = true;
    };

    ".config/mimeapps.list" = {
      source = ./config/mimeapps.list;
      force = true;
    };

    # Nerd Font (JetBrains Mono) for icon glyphs
    ".config/fontconfig/conf.d/10-nerdfonts.conf" = {
      source = ./config/fontconfig/nerdfonts.conf;
      force = true;
    };

    # Clipboard history rofi script
    ".local/bin/cliphist-rofi.sh" = {
      source = ./config/scripts/cliphist-rofi.sh;
      force = true;
    };

    # kari PiP — Super+P toggle (float + pin corner for mpv)
    ".local/bin/kari-pip.sh" = {
      source = ./config/scripts/kari-pip.sh;
      executable = true;
      force = true;
    };

    # Rofi config + theme (Vanta Black)
    ".config/rofi/config.rasi" = {
      source = ./config/rofi/config.rasi;
      force = true;
    };

    ".config/rofi/theme.rasi" = {
      source = ./config/rofi/theme.rasi;
      force = true;
    };

    # Bar switcher (single mechanism: QS_ACTIVE_BAR env, quickshell from PATH)
    ".local/bin/bar-switch.sh" = {
      source = ./config/scripts/bar-switch.sh;
      executable = true;
      force = true;
    };

    # Sober (Roblox) launcher that forces the NVIDIA dGPU inside the flatpak
    # sandbox (VK_ICD + libvulkan.so alias; needs the flatpak override from
    # README — applied manually once per machine)
    ".local/bin/sober-nvidia" = {
      source = ./config/scripts/sober-nvidia;
      executable = true;
      force = true;
    };

    # LibreWolf .desktop — librewolf-bin-unwrapped ships no desktop file,
    # so without this rofi -show drun (SUPER+R) can't see it
    ".local/share/applications/librewolf.desktop" = {
      text = ''
        [Desktop Entry]
        Name=LibreWolf
        Comment=Private web browser
        Exec=librewolf %u
        Icon=librewolf
        Type=Application
        StartupNotify=true
        Categories=Network;WebBrowser;
        MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
      '';
      force = true;
    };

    # Claude Desktop .desktop entry (uses wrapper with X11 flags for NVIDIA Wayland fix)
    ".local/share/applications/claude-desktop.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Claude
        Comment=Desktop application for Claude.ai
        GenericName=AI Assistant
        Keywords=AI;Chat;Assistant;Claude;Code;LLM;
        Exec=claude-desktop %U
        Icon=claude-desktop
        Type=Application
        StartupNotify=true
        StartupWMClass=com.anthropic.Claude
        SingleMainWindow=true
        Categories=Utility;Development;
        MimeType=x-scheme-handler/claude;
        Actions=NewChat;NewCode;

        [Desktop Action NewChat]
        Name=New Chat
        Exec=claude-desktop "claude://claude.ai/new?surface=chat&source=desktop_action"

        [Desktop Action NewCode]
        Name=New Claude Code Session
        Exec=claude-desktop "claude://code/new?source=desktop_action"
      '';
      force = true;
    };

    # Fan control + PC mount helpers (MSI GF63 EC fan scripts + power menu)
    ".local/bin/fan" = {
      source = ./config/scripts/fan;
      executable = true;
      force = true;
    };
    ".local/bin/fan-lib.sh" = {
      source = ./config/scripts/fan-lib.sh;
      executable = true;
      force = true;
    };
    ".local/bin/fan-max.sh" = {
      source = ./config/scripts/fan-max.sh;
      executable = true;
      force = true;
    };
    ".local/bin/fan-middle.sh" = {
      source = ./config/scripts/fan-middle.sh;
      executable = true;
      force = true;
    };
    ".local/bin/fan-silent.sh" = {
      source = ./config/scripts/fan-silent.sh;
      executable = true;
      force = true;
    };
    ".local/bin/power-menu.sh" = {
      source = ./config/scripts/power-menu.sh;
      executable = true;
      force = true;
    };
    # Boot fan profile (read by msi-fan-boot.service via apply-boot-profile.sh)
    ".local/bin/boot" = {
      source = ./config/scripts/boot;
      recursive = true;
      executable = true;
      force = true;
    };

    ".local/bin/pc-mount" = {
      source = ./config/scripts/pc-mount;
      executable = true;
      force = true;
    };

  };
}