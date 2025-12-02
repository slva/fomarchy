# Fomarchy: Omarchy per Fedora 43

Aquest projecte aporta scripts i configuracions perquè una instal·lació existent de Fedora 43 repliqui l'experiència d'Omarchy sense canviar de distribució.

## Prerequisits

- Fedora Workstation 43 actualitzat i accés `sudo`.
- Connexió a Internet i mínim 20 GB lliures.
- Opcional: còpia de seguretat del teu `$HOME` abans d'executar els scripts.

## Flux recomanat

```
sudo ./scripts/00-prereqs.sh
sudo ./scripts/10-packages.sh
./scripts/15-flatpak.sh
sudo ./scripts/20-hyprland.sh
./scripts/30-dotfiles.sh
sudo ./scripts/40-services.sh
./scripts/checklist.sh
```

Algunes notes:

- `scripts/15-flatpak.sh` i `scripts/30-dotfiles.sh` només necessiten permisos d'usuari.
- El script de dotfiles crearà còpies de seguretat (`.bak.TIMESTAMP`) abans de sobreescriure.
- Pots reexecutar qualsevol script sense problemes: totes les instal·lacions són idempotents.
- Després d'instal·lar tmux, executa `tmux` i prem `Ctrl-a + I` per instal·lar els plugins.
- Les configuracions de polkit permeten gestionar brightness i xarxa sense contrasenya.

## Contingut

- [`docs/requirements.md`](docs/requirements.md) — resum de dependències i configuracions clau.
- [`config/`](config/) — dotfiles i configuracions de Hyprland/Waybar.
- [`systemd/`](systemd/) — unitats de servei per sistema i usuari.

## Checklist

Executa `scripts/checklist.sh` per revisar:
- versions d'eines (Hyprland, Waybar, Starship, Rust, Flatpak, etc.),
- serveis d'usuari actius (`waybar`, `hyprpaper`, `wlsunset`),
- serveis del sistema com `powertop`, `tlp` i `bluetooth`,
- dotfiles configurats (zsh, bash, starship, tmux, etc.),
- configuracions de polkit per brightness i xarxa.

## Revertir canvis

1. Desactiva serveis:
   - `systemctl --user disable --now waybar.service hyprpaper.service wlsunset.service`
   - `sudo systemctl disable --now powertop.service tlp.service`
2. Elimina enllaços simbòlics creats per `scripts/30-dotfiles.sh` i restaura els `.bak`.
3. Desinstal·la paquets amb `sudo dnf remove ...` segons calgui.

## Inspiració

Basat en el manual oficial d'Omarchy i adaptat específicament a Fedora 43.



