#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_root

HYPR_PACKAGES=(
  hyprland
  hyprpaper
  hypridle
  hyprlock
  waybar
  swaync
  wlsunset
  xdg-desktop-portal-hyprland
  xdg-desktop-portal-gtk
  qt5-qtwayland
  qt6-qtwayland
  xorg-x11-server-Xwayland
)

info "Instal·lant paquets Hyprland i entorn Wayland"
dnf install -y "${HYPR_PACKAGES[@]}"

info "Paquets Hyprland instal·lats"



