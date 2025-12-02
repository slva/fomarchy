# Requeriments d'Omarchy per Fedora 43

Aquest document resumeix els elements que Omarchy desplega en una instal·lació manual segons [el manual oficial](https://learn.omacom.io/2/the-omarchy-manual/96/manual-installation) i els adapta a Fedora 43. Ens serveix per validar que tots els scripts cobreixen les mateixes peces.

## Dependències del sistema

- Accés `sudo`, connexió a Internet estable i Fedora 43 actualitzat (`sudo dnf upgrade -y`).
- Repositoris addicionals: `rpmfusion-free`, `rpmfusion-nonfree`, repositoris COPR per Hyprland i utilitats (p. ex. `solopasha/hyprland`), i Flathub activat.
- Fonts: JetBrains Mono Nerd Font, Inter, Noto CJK, Bravura, fonts emoji (Noto Color Emoji) tal com proposa Omarchy.
- Codecs multimèdia: `ffmpeg`, `pipwire-codec-aptx`, `gstreamer1-plugin-openh264`, `libdvdcss`.

## Paquets base

| Categoria | Paquets principals |
| --- | --- |
| Shell i terminal | `zsh`, `starship`, `tmux`, `kitty`, `alacritty`, `bash-completion` |
| Eines CLI | `git`, `fd-find`, `ripgrep`, `jq`, `yq`, `htop`, `btop`, `fastfetch` |
| Desenvolupament | `gcc`, `clang`, `cmake`, `make`, `python3-pip`, `nodejs`, `npm`, `go`, `rustup` |
| Sistemes | `podman`, `podman-compose`, `ansible`, `systemd-oomd-defaults` |
| Multimedia | `mpv`, `swappy`, `grim`, `slurp`, `thunar`, `imv` |
| Disseny | `inkscape`, `gimp`, `krita`, `fontconfig` |

Els scripts també han de suportar paquets conditionals per maquinari (per exemple, `tlp` per portàtils o `power-profiles-daemon`).

## Components gràfics i Hyprland

- **Hyprland** amb el seu portal i dependències (`hyprland`, `hyprpaper`, `hypridle`).
- **Waybar** personalitzat, `swaylock-effects`, `wofi`/`tofi`, `wlogout`.
- Suport d'entrada: `wl-clipboard`, `cliphist`, `imv`, `pavucontrol`, `pactl`.
- Paquets per integració Wayland/XWayland (`xorg-x11-server-Xwayland`, `xdg-desktop-portal-hyprland`).

## Flatpak

- Activació de Flathub (`flatpak remote-add --if-not-exists flathub …`).
- Aplicacions destacades: `com.spotify.Client`, `md.obsidian.Obsidian`, `com.discordapp.Discord`, `org.mozilla.firefox`, `com.github.tchx84.Flatseal`.

## Dotfiles i configuracions

- Directori `config/dotfiles` conté: `zsh/.zshrc`, `bash/.bashrc`, `kitty/kitty.conf`, `alacritty/alacritty.toml`, `git/.gitconfig`, `nvim/init.lua`.
- Directori `config/hypr` amb `hyprland.conf`, `hyprpaper.conf`, escripts d'autostart i temes Gruvbox inspirats en Omarchy.
- Directori `config/waybar` amb temes JSON/CSS, scripts per mòduls (CPU, temps, bateria) i fonts requerides.

## Serveis i systemd

- Unitats `systemd --user` per autoarrencar Waybar, wlsunset, scripts de notificacions.
- Unitats `systemd` del sistema: `tlp`, `bluetooth`, `powertop`, `power-profiles-daemon`, `docker` opcional.
- Fitxers `polkit` per permetre gestió de brightness i accions de xarxa sense contrasenya.

## Scripts i flux d'execució

1. `scripts/00-prereqs.sh` — comprova versió Fedora, avisa sobre backups i habilita repos RPM Fusion/COPR.
2. `scripts/10-packages.sh` — instal·la paquets base i fonts.
3. `scripts/15-flatpak.sh` — configura Flathub i instal·la apps Flatpak.
4. `scripts/20-hyprland.sh` — instal·la Hyprland + components.
5. `scripts/30-dotfiles.sh` — crea backups i enllaços simbòlics dels dotfiles.
6. `scripts/40-services.sh` — activa serveis i copia unitats.
7. `scripts/checklist.sh` — verifica versions, serveis actius i recorda passos manuals.

Aquesta estructura garanteix un procés repetible i modular que replica la funcionalitat d'Omarchy sense construir una distribució pròpia.



