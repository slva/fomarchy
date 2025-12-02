#!/usr/bin/env bash
#
# Funcions comunes pels scripts d'instal·lació de Fomarchy (Omarchy per Fedora).

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_PREFIX="[fomarchy]"

color() {
  local code="$1"; shift
  printf '\033[%sm%s\033[0m\n' "$code" "$*"
}

info()   { color '1;34' "${LOG_PREFIX} $*"; }
warn()   { color '1;33' "${LOG_PREFIX} WARNING: $*"; }
error()  { color '1;31' "${LOG_PREFIX} ERROR: $*"; }

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    error "Cal executar aquest script amb sudo."
    exit 1
  fi
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    error "Comanda requerida no trobada: $cmd"
    exit 1
  fi
}

run_or_skip() {
  local description="$1"; shift
  local cmd=("$@")
  if "${cmd[@]}"; then
    info "$description"
  else
    warn "No s'ha pogut completar: $description"
  fi
}

enable_repo() {
  local repo_script="$1"
  if ! dnf repolist --enabled | grep -q "$repo_script"; then
    info "Activant repo: $repo_script"
    dnf install -y "$repo_script"
  else
    info "Repo ja actiu: $repo_script"
  fi
}

ensure_package() {
  local pkg="$1"
  if rpm -q "$pkg" >/dev/null 2>&1; then
    info "Paquet ja instal·lat: $pkg"
  else
    info "Instal·lant paquet: $pkg"
    dnf install -y "$pkg"
  fi
}

ensure_flatpak() {
  local ref="$1"
  if flatpak info "$ref" >/dev/null 2>&1; then
    info "Flatpak ja instal·lat: $ref"
  else
    info "Instal·lant Flatpak: $ref"
    flatpak install -y flathub "$ref"
  fi
}

backup_and_link() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "${dest}.bak.$(date +%s)"
  fi
  ln -sfn "$src" "$dest"
  info "Enllaç creat: $dest -> $src"
}



