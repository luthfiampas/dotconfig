# arch-sway

A curated collection of configuration files for **Arch Linux** with a **minimal base install** using **Sway** as the window manager.

The included installation script is designed to be used on a **fresh Arch Linux install**. It will set up essential software, configurations, and theming for a functional Sway-based environment.

## Installation

```bash
git clone https://github.com/luthfiampas/dotconfig
cd dotconfig/arch-sway
./_install.sh
```

Once the script completes, a system **reboot is recommended**.

## Post-installation notes

### Missing icons in DB Browser for SQLite

If icons are missing, install the following packages:

```bash
yay -S qt5ct qt6ct
```

Then reopen the application. Once icons appear, these packages can be safely removed if desired.

### Configuring `spotify_player`

Retrieve your Client ID from [Spotify Developer Dashboard](https://developer.spotify.com/dashboard), then edit `~/.config/spotify_player/app.toml` and set the `client_id` value.
