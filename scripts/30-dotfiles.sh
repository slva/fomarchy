#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(eval echo "~${TARGET_USER}")"

if [[ "${EUID}" -eq 0 ]]; then
  warn "Aquest script és millor executar-lo com a usuari normal. Continuant igualment..."
fi

link_tree() {
  local src_dir="$1"
  local dest_base="$2"
  find "$src_dir" -type f | while read -r file; do
    local rel="${file#$src_dir/}"
    backup_and_link "$file" "${dest_base}/${rel}"
  done
}

info "Aplicant dotfiles a ${TARGET_HOME}"

link_tree "${ROOT_DIR}/config/dotfiles" "${TARGET_HOME}"
link_tree "${ROOT_DIR}/config/hypr" "${TARGET_HOME}/.config/hypr"
link_tree "${ROOT_DIR}/config/waybar" "${TARGET_HOME}/.config/waybar"

# Starship config goes to .config/starship.toml
if [[ -f "${ROOT_DIR}/config/dotfiles/starship.toml" ]]; then
  backup_and_link "${ROOT_DIR}/config/dotfiles/starship.toml" "${TARGET_HOME}/.config/starship.toml"
fi

# Ghostty config goes to .config/ghostty/config
if [[ -f "${ROOT_DIR}/config/dotfiles/ghostty/config" ]]; then
  mkdir -p "${TARGET_HOME}/.config/ghostty"
  backup_and_link "${ROOT_DIR}/config/dotfiles/ghostty/config" "${TARGET_HOME}/.config/ghostty/config"
fi

# Ensure tmux plugin manager directory exists
mkdir -p "${TARGET_HOME}/.tmux/plugins"

# Instal·lar tmux plugin manager si no existeix
if [[ ! -d "${TARGET_HOME}/.tmux/plugins/tpm" ]]; then
  info "Instal·lant tmux plugin manager..."
  runuser -l "${TARGET_USER}" -c "git clone https://github.com/tmux-plugins/tpm ${TARGET_HOME}/.tmux/plugins/tpm" || warn "No s'ha pogut instal·lar tpm (cal connexió a Internet)"
fi

info "Dotfiles aplicats correctament"
info "Nota: Després d'instal·lar tmux, executa 'tmux' i prem 'Ctrl-a + I' per instal·lar els plugins"



