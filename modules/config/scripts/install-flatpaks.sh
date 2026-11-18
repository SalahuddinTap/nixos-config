#!/usr/bin/env bash
# One-shot flatpak app install for a fresh restore (idempotent).
# Usage: install-flatpaks.sh   (system apps need sudo; user app does not)
set -euo pipefail

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

for app in app.zen_browser.zen org.vinegarhq.Vinegar org.vinegarhq.Sober; do
  if ! flatpak info --system "$app" >/dev/null 2>&1; then
    sudo flatpak install -y flathub "$app"
  fi
done

# Stremio was a user-level install on the original machine
if ! flatpak info --user com.stremio.Stremio >/dev/null 2>&1; then
  flatpak install -y --user flathub com.stremio.Stremio
fi

echo "Flatpaks done."
