#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_command flatpak

REMOTE_NAME="flathub"
REMOTE_URL="https://flathub.org/repo/flathub.flatpakrepo"

if ! flatpak remotes | grep -q "^${REMOTE_NAME}"; then
  info "Afegint remot Flathub"
  flatpak remote-add --if-not-exists "${REMOTE_NAME}" "${REMOTE_URL}"
else
  info "Flathub ja configurat"
fi

FLATPAKS=(
  com.spotify.Client
  com.discordapp.Discord
  com.slack.Slack
  com.github.tchx84.Flatseal
  org.mozilla.firefox
  md.obsidian.Obsidian
  org.gimp.GIMP
  org.inkscape.Inkscape
)

for ref in "${FLATPAKS[@]}"; do
  ensure_flatpak "$ref"
done

info "Instal·lació de Flatpaks completada"



