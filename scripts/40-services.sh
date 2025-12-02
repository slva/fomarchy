#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_root

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(eval echo "~${TARGET_USER}")"

info "Copiant unitats systemd d'usuari"
install -Dm644 "${ROOT_DIR}/systemd/user/waybar.service" "${TARGET_HOME}/.config/systemd/user/waybar.service"
install -Dm644 "${ROOT_DIR}/systemd/user/hyprpaper.service" "${TARGET_HOME}/.config/systemd/user/hyprpaper.service"
install -Dm644 "${ROOT_DIR}/systemd/user/wlsunset.service" "${TARGET_HOME}/.config/systemd/user/wlsunset.service"
chown -R "${TARGET_USER}:${TARGET_USER}" "${TARGET_HOME}/.config/systemd"

runuser -l "${TARGET_USER}" -c "systemctl --user daemon-reload"
runuser -l "${TARGET_USER}" -c "systemctl --user enable --now waybar.service hyprpaper.service wlsunset.service"

info "Instal·lant unitats del sistema"
install -Dm644 "${ROOT_DIR}/systemd/system/powertop.service" "/etc/systemd/system/powertop.service"
systemctl daemon-reload
systemctl enable --now powertop.service tlp.service

# Activar bluetooth si està disponible
if systemctl list-unit-files | grep -q bluetooth.service; then
  systemctl enable --now bluetooth.service || warn "Bluetooth no disponible"
fi

info "Configurant polkit per brightness i xarxa"
POLKIT_DIR="/etc/polkit-1/rules.d"
mkdir -p "${POLKIT_DIR}"

# Polkit rule per brightness (brightnessctl)
cat > "${POLKIT_DIR}/10-brightness.rules" << 'EOF'
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.set-backlight-brightness" ||
        action.id == "org.freedesktop.login1.set-backlight-brightness") {
        if (subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    }
});
EOF

# Polkit rule per xarxa (NetworkManager)
cat > "${POLKIT_DIR}/10-network.rules" << 'EOF'
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0) {
        if (subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    }
});
EOF

chmod 644 "${POLKIT_DIR}/10-brightness.rules" "${POLKIT_DIR}/10-network.rules"

info "Serveis i polkit configurats"



