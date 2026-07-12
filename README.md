# dotfiles

personal configuration for arch linux with hyprland.

the goal is a functional, distraction-free environment with as few moving
parts as possible. no themes, no plugin managers, no unnecessary daemons.
just what is needed to work.


## stack

- compositor: hyprland
- bar: waybar
- terminal: kitty
- launcher: fuzzel
- wallpaper: hyprpaper
- lock: hyprlock
- notifications: mako
- file manager: thunar (+ thunar-archive-plugin, file-roller for archives)
- screenshots: grim + slurp + satty
- networking: NetworkManager + iwd
- input: fcitx5 + mozc
- login: sddm + silentsddm


## requirements

- arch linux with yay installed
- git installed (needed before running the script, since it clones SilentSDDM)
- a wallpaper at `~/media/pictures/wallpapers/wallpaper.jpg`
- monitors named `eDP-1` and `HDMI-A-1`, edit `hypr/hyprland.lua` if yours differ


## install

```bash
git clone https://github.com/USERNAME/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```


## after install

open `fcitx5-configtool` and add Mozc as an input method.

copy your wallpaper into the sddm theme:

```bash
sudo cp ~/media/pictures/wallpapers/wallpaper.jpg \
    /usr/share/sddm/themes/silent/backgrounds/wallpaper.jpg
```

for a user avatar on the login screen, place a square image at `~/.face.icon`
and copy it to `/var/lib/AccountsService/icons/gus`.

if login takes ~1-2 minutes after entering the password, check for a
lingering `systemd-networkd` conflicting with NetworkManager:

```bash
systemctl status systemd-networkd.service --no-pager
```

the install script already disables it, but some arch ISOs re-enable it
on later updates. if it's active, disable it:

```bash
sudo systemctl disable --now systemd-networkd.service systemd-networkd-wait-online.service
```
