#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_root
require_command dnf

FEDORA_VERSION="$(rpm -E %fedora)"
TARGET_VERSION="43"

if [[ "${FEDORA_VERSION}" != "${TARGET_VERSION}" ]]; then
  warn "S'està executant a Fedora ${FEDORA_VERSION}, però el perfil està provat a Fedora ${TARGET_VERSION}."
  read -rp "Vols continuar igualment? [y/N] " reply
  [[ "${reply}" =~ ^[Yy]$ ]] || exit 1
fi

info "Actualitzant paquets del sistema"
dnf upgrade -y

info "Activant RPM Fusion"
enable_repo https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"${FEDORA_VERSION}".noarch.rpm
enable_repo https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"${FEDORA_VERSION}".noarch.rpm

info "Activant COPR de Hyprland"
dnf -y copr enable solopasha/hyprland

info "Activant COPR de Ghostty"
dnf -y copr enable scottames/ghostty

info "Prerequisits completats"



