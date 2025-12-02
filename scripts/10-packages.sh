#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_root
require_command dnf

BASE_PACKAGES=(
  # shell
  zsh starship tmux kitty alacritty ghostty bash-completion
  zsh-syntax-highlighting zsh-autosuggestions
  # cli
  git fd-find ripgrep jq yq htop btop fastfetch eza bat fzf brightnessctl
  # dev
  gcc gcc-c++ clang clang-tools-extra cmake make python3-pip nodejs npm golang rustup toolchain source-highlight
  # sys
  podman podman-compose ansible systemd-oomd-defaults powertop tlp dnf-plugins-core
  # multimedia
  mpv swappy grim slurp thunar imv pavucontrol wl-clipboard cliphist swaylock-effects wofi wlogout playerctl
  # design
  krita
  # network/tools
  wget curl unzip openssl gnome-keyring seahorse sshpass
)

FONTS_PACKAGES=(
  jetbrains-mono-nf-fonts
  google-noto-serif-cjk-fonts
  google-noto-sans-mono-fonts
  google-noto-emoji-color-fonts
  inter-fonts
  bravura-fonts
)

CODECS_PACKAGES=(
  ffmpeg
  gstreamer1-libav
  gstreamer1-plugin-openh264
  gstreamer1-vaapi
  libdvdcss
  pipewire-codec-aptx
)

info "Instal·lant paquets base (${#BASE_PACKAGES[@]})"
dnf install -y "${BASE_PACKAGES[@]}"

info "Instal·lant fonts"
dnf install -y "${FONTS_PACKAGES[@]}"

info "Instal·lant codecs multimèdia"
dnf install -y "${CODECS_PACKAGES[@]}"

info "Configurant Rustup i Node.js per l'usuari principal"
runuser -l "${SUDO_USER:-$USER}" -c "rustup default stable" || true
runuser -l "${SUDO_USER:-$USER}" -c "npm install -g yarn pnpm" || true

info "Scripts de paquets completats"

