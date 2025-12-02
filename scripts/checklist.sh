#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

info "=== Verificació de components de Fomarchy ==="
echo ""

# Paquets principals
info "Paquets principals:"
checks=(
  "Hyprland: $(hyprland -v 2>/dev/null | head -n1 || echo 'no instal·lat')"
  "Waybar: $(waybar --version 2>/dev/null || echo 'no instal·lat')"
  "Starship: $(starship --version 2>/dev/null || echo 'no instal·lat')"
  "Ghostty: $(ghostty --version 2>/dev/null | head -n1 || echo 'no instal·lat')"
  "Kitty: $(kitty --version 2>/dev/null || echo 'no instal·lat')"
  "Alacritty: $(alacritty --version 2>/dev/null | head -n1 || echo 'no instal·lat')"
  "Tmux: $(tmux -V 2>/dev/null || echo 'no instal·lat')"
  "Zsh: $(zsh --version 2>/dev/null || echo 'no instal·lat')"
)

for item in "${checks[@]}"; do
  echo "  ✓ $item"
done
echo ""

# Eines CLI
info "Eines CLI:"
cli_tools=(
  "bat: $(bat --version 2>/dev/null | head -n1 || echo 'no instal·lat')"
  "fzf: $(fzf --version 2>/dev/null || echo 'no instal·lat')"
  "brightnessctl: $(brightnessctl --version 2>/dev/null | head -n1 || echo 'no instal·lat')"
  "eza: $(eza --version 2>/dev/null || echo 'no instal·lat')"
  "ripgrep: $(rg --version 2>/dev/null | head -n1 || echo 'no instal·lat')"
)

for item in "${cli_tools[@]}"; do
  echo "  ✓ $item"
done
echo ""

# Plugins de Zsh
info "Plugins de Zsh:"
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  echo "  ✓ zsh-syntax-highlighting instal·lat"
else
  warn "  ✗ zsh-syntax-highlighting no trobat"
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  echo "  ✓ zsh-autosuggestions instal·lat"
else
  warn "  ✗ zsh-autosuggestions no trobat"
fi
echo ""

# Desenvolupament
info "Eines de desenvolupament:"
dev_tools=(
  "Rustup: $(rustup show active-toolchain 2>/dev/null || echo 'no configurat')"
  "Node.js: $(node --version 2>/dev/null || echo 'no instal·lat')"
  "npm: $(npm --version 2>/dev/null || echo 'no instal·lat')"
  "Go: $(go version 2>/dev/null | head -n1 || echo 'no instal·lat')"
  "Python: $(python3 --version 2>/dev/null || echo 'no instal·lat')"
)

for item in "${dev_tools[@]}"; do
  echo "  ✓ $item"
done
echo ""

# Flatpak
info "Flatpak:"
echo "  ✓ $(flatpak --version)"
flatpak_count=$(flatpak list 2>/dev/null | wc -l)
echo "  ✓ Aplicacions instal·lades: $flatpak_count"
echo ""

# Dotfiles
info "Dotfiles configurats:"
dotfiles=(
  "$HOME/.zshrc"
  "$HOME/.bashrc"
  "$HOME/.config/starship.toml"
  "$HOME/.tmux.conf"
  "$HOME/.config/hypr/hyprland.conf"
  "$HOME/.config/waybar/config.jsonc"
  "$HOME/.config/ghostty/config"
  "$HOME/.config/kitty/kitty.conf"
  "$HOME/.config/alacritty/alacritty.toml"
)

for dotfile in "${dotfiles[@]}"; do
  if [ -f "$dotfile" ] || [ -L "$dotfile" ]; then
    echo "  ✓ $(basename "$dotfile")"
  else
    warn "  ✗ $(basename "$dotfile") no trobat"
  fi
done
echo ""

# Serveis d'usuari
info "Serveis d'usuari (systemd --user):"
user_services=("waybar.service" "hyprpaper.service" "wlsunset.service")
for service in "${user_services[@]}"; do
  if systemctl --user is-active --quiet "$service" 2>/dev/null; then
    echo "  ✓ $service actiu"
  else
    warn "  ✗ $service no actiu"
  fi
done
echo ""

# Serveis del sistema
info "Serveis del sistema:"
system_services=("powertop.service" "tlp.service" "bluetooth.service")
for service in "${system_services[@]}"; do
  if systemctl is-active --quiet "$service" 2>/dev/null; then
    echo "  ✓ $service actiu"
  elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
    echo "  ⚠ $service habilitat però no actiu"
  else
    warn "  ✗ $service no configurat"
  fi
done
echo ""

# Polkit
info "Configuracions de Polkit:"
if [ -f /etc/polkit-1/rules.d/10-brightness.rules ]; then
  echo "  ✓ Regla de brightness configurada"
else
  warn "  ✗ Regla de brightness no trobada"
fi

if [ -f /etc/polkit-1/rules.d/10-network.rules ]; then
  echo "  ✓ Regla de xarxa configurada"
else
  warn "  ✗ Regla de xarxa no trobada"
fi
echo ""

info "=== Verificació completada ==="



