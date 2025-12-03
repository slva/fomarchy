#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_root
require_command dnf

BASE_PACKAGES=(
  # shell
  zsh tmux kitty alacritty ghostty bash-completion
  zsh-syntax-highlighting zsh-autosuggestions
  # cli
  git fd-find ripgrep jq yq htop btop fastfetch bat fzf brightnessctl
  # dev
  gcc gcc-c++ clang clang-tools-extra cmake make python3-pip nodejs npm golang rustup source-highlight
  # sys
  podman podman-compose ansible systemd-oomd-defaults powertop tlp dnf-plugins-core
  # multimedia
  mpv swappy grim slurp thunar imv pavucontrol wl-clipboard cliphist swaylock-effects wofi wlogout playerctl

  # sys
  podman podman-compose ansible systemd-oomd-defaults powertop tlp dnf-plugins-core
  # multimedia
  mpv swappy grim slurp thunar imv pavucontrol wl-clipboard cliphist swaylock-effects wofi wlogout playerctl

  # network/tools
  wget curl unzip openssl gnome-keyring seahorse sshpass
)

info "Instal·lant paquets base (${#BASE_PACKAGES[@]})"
dnf install -y "${BASE_PACKAGES[@]}"

# Install fonts using the custom script
info "Instal·lant fonts personalitzades"
"${SCRIPT_DIR}/12-fonts.sh"

info "Configurant Rustup i Node.js per l'usuari principal"
runuser -l "${SUDO_USER:-$USER}" -c "rustup default stable" || true
runuser -l "${SUDO_USER:-$USER}" -c "npm install -g yarn pnpm" || true

info "Scripts de paquets completats"

