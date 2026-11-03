# Declarative pi package management via pi-packages.nix (github:Leoguy77/pi-packages.nix).
#
# STATUS: staged, NOT active. pi currently manages its packages itself via
# `pi install npm:...` (see ~/.pi/agent/settings.json "packages").
#
# To migrate fully to nix-managed packages (reproducible, no runtime npm install):
#   1. Set enable = true and fill `packages` below with the package keys
#      (same names as the npm packages, e.g. "pi-mcp-adapter").
#   2. Remove the npm: entries from ~/.pi/agent/settings.json "packages"
#      (the module writes store paths there; keeping both double-loads extensions).
#   3. Optionally add the Attic binary cache to nix.settings so Tier-B packages
#      don't build from source:
#        extra-substituters = [ "https://nix-cache.lsinfra.de/pi-packages" ];
#        extra-trusted-public-keys = [ "pi-packages:OF+SNU2ALJB8M+cQP/RfFOuKIOMN0w4WiV8k01pvUC4=" ];
#   4. sudo nixos-rebuild switch --flake .#nixos
#
# Current pi packages (keep in sync if you activate this):
#   pi-web-access pi-memory @firstpick/pi-skill-frontend-design pi-frontend-create
#   principal-pi-skills pi-gitnexus pi-subagents pi-mcp-adapter @upstash/context7-pi
#   @mattschoe/pi-plan @gotgenes/pi-permission-system @juicesharp/rpiv-ask-user-question
#   pi-lens pi-vetter cc-safety-net @narumitw/pi-statusline @narumitw/pi-btw
#   @juicesharp/rpiv-todo @narumitw/pi-worktree pi-code @narumitw/pi-usage pi-rewind
#   pi-ide-context @quintinshaw/pi-dynamic-workflows

{ inputs, lib, ... }:
{
  imports = [ inputs.pi-packages.nixosModules.default ];

  # The module only acts when packages is non-empty; empty list = no-op.
  # To activate: uncomment packages, remove npm: entries from ~/.pi/agent/settings.json, rebuild.
  programs.pi.coding-agent.packages = [
    # "pi-mcp-adapter"
    # "pi-subagents"
  ];
}
