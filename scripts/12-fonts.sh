#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

require_root

install_font() {
  local font_name="$1"
  local download_url="$2"
  local temp_file="/tmp/${font_name}_download" # Renamed to be generic
  local temp_extract_dir="/tmp/${font_name}_extracted"
  local font_install_dir="/usr/local/share/fonts/${font_name}"

  info "Installing ${font_name}..."

  # Create install directory
  mkdir -p "${font_install_dir}"

  # Download
  info "Downloading ${font_name} from ${download_url}"
  curl -L -o "${temp_file}" "${download_url}"

  # Determine file type and process
  local file_mime_type=$(file --mime-type -b "${temp_file}")
  info "Detected MIME type: ${file_mime_type}"

  # If it's HTML, save it for inspection
  if [[ "${file_mime_type}" == "text/html" ]]; then
    cp "${temp_file}" "/tmp/${font_name}_downloaded.html"
  fi

  if [[ "${file_mime_type}" == "application/zip" || ( "${file_mime_type}" == "application/octet-stream" && $(unzip -t "${temp_file}" &>/dev/null; echo $?) == 0 ) ]]; then
    # If it's a zip or an octet-stream that passes unzip -t
    info "Extracting ${font_name} from zip to ${temp_extract_dir}"
    mkdir -p "${temp_extract_dir}"
    unzip -o "${temp_file}" -d "${temp_extract_dir}"
    info "Copying ${font_name} font files to ${font_install_dir}"
    find "${temp_extract_dir}" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "${font_install_dir}/" \;
    rm -rf "${temp_extract_dir}"
  elif [[ "${file_mime_type}" == "font/ttf" || "${file_mime_type}" == "font/otf" ]]; then
    info "Copying direct font file ${font_name} to ${font_install_dir}"
    cp "${temp_file}" "${font_install_dir}/"
  else
    error "Unsupported file type (${file_mime_type}) for ${font_name} download: ${download_url}"
    rm -f "${temp_file}"
    return 1
  fi

  # Clean up downloaded file
  info "Cleaning up temporary download file for ${font_name}"
  rm -f "${temp_file}"
}

# JetBrains Mono NF
JB_MONO_NF_VERSION="2.3.0" # A specific version to avoid breaking changes, can be updated later
JB_MONO_NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${JB_MONO_NF_VERSION}/JetBrainsMono.zip"
install_font "JetBrainsMonoNF" "${JB_MONO_NF_URL}"

# Noto Serif CJK
# Using a specific release from googlei18n/noto-cjk
NOTO_SERIF_CJK_VERSION="Serif2.003" # Latest stable release
NOTO_SERIF_CJK_URL="https://github.com/notofonts/noto-cjk/releases/download/${NOTO_SERIF_CJK_VERSION}/05_NotoSerifCJKOTF.zip"
install_font "NotoSerifCJK" "${NOTO_SERIF_CJK_URL}"

# Noto Sans Mono
# Google Fonts usually provides direct download via a structured URL
NOTO_SANS_MONO_URL="https://fonts.google.com/download?family=Noto%20Sans%20Mono"
install_font "NotoSansMono" "${NOTO_SANS_MONO_URL}"

# Noto Emoji Color
# Using a specific release from googlefonts/noto-emoji
NOTO_EMOJI_VERSION="2.038" # Latest stable release with color emoji
NOTO_EMOJI_URL="https://github.com/googlefonts/noto-emoji/releases/download/v${NOTO_EMOJI_VERSION}/NotoColorEmoji.ttf"
install_font "NotoEmojiColor" "${NOTO_EMOJI_URL}" # This is a direct TTF, not a zip, need to adjust install_font or handle separately.
# For NotoColorEmoji.ttf, the install_font function will try to unzip it, which will fail.
# I need to modify install_font to handle direct font files or create a separate function.
# For now, I'll modify install_font to check if the downloaded file is a zip or a font file.

# Re-evaluating install_font for direct font files vs zips
# It's better to make install_font handle single font files directly.

# Inter
# Google Fonts direct download
INTER_URL="https://fonts.google.com/download?family=Inter"
install_font "Inter" "${INTER_URL}"

# Bravura
# From SMuFL GitHub releases
BRAVURA_VERSION="1.392" # Latest stable version
BRAVURA_URL="https://github.com/smufl/Bravura/releases/download/v${BRAVURA_VERSION}/Bravura_1.392.zip"
install_font "Bravura" "${BRAVURA_URL}"

# CaskaydiaCove Nerd Font
CASKAYDIACODE_NF_VERSION="3.0.2"
CASKAYDIACODE_NF_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${CASKAYDIACODE_NF_VERSION}/CascadiaCode.zip"
install_font "CaskaydiaCoveNF" "${CASKAYDIACODE_NF_URL}"


info "Updating font cache..."
fc-cache -f -v

info "Font installation script completed."
