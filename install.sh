#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
step() { printf "  %s\n" "$1"; }

echo "dotfiles"
echo ""

# ── packages ──────────────────────────────────────────────────────────────────

step "packages..."

sudo pacman -S --needed --noconfirm \
    hyprland hyprpaper hyprlock waybar kitty fuzzel mako socat \
    brightnessctl playerctl wireplumber pavucontrol \
    ttf-jetbrains-mono-nerd noto-fonts-cjk \
    fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-mozc \
    greetd gstreamer gst-plugins-base gst-plugins-good

step "aur packages..."

yay -S --needed --noconfirm greetd-regreet otf-ipafont

# ── configs ───────────────────────────────────────────────────────────────────

step "configs..."

for app in hypr waybar kitty fuzzel; do
    mkdir -p "$HOME/.config/$app"
    cp -r "$DOTFILES/$app/"* "$HOME/.config/$app/"
done

chmod +x "$HOME/.config/hypr/scripts/monitor-hotplug.sh"
fc-cache -fv > /dev/null 2>&1

# ── greetd ────────────────────────────────────────────────────────────────────

step "greetd..."

sudo cp "$DOTFILES/greetd/"* /etc/greetd/
sudo chmod +x /etc/greetd/start-greeter.sh
sudo mkdir -p /var/lib/regreet /var/log/regreet
sudo chown greeter:greeter /var/lib/regreet /var/log/regreet

# copy wallpaper if it exists
WALLPAPER="$HOME/media/pictures/wallpapers/wallpaper.jpg"
if [ -f "$WALLPAPER" ]; then
    sudo cp "$WALLPAPER" /etc/greetd/wallpaper.jpg
    step "wallpaper copied"
else
    step "wallpaper not found — add it manually to /etc/greetd/wallpaper.jpg"
fi

# ── services ──────────────────────────────────────────────────────────────────

step "services..."

sudo systemctl enable greetd
sudo systemctl set-default graphical.target

# ── done ──────────────────────────────────────────────────────────────────────

echo ""
echo "done."
echo ""
echo "  open fcitx5-configtool and add mozc"
echo "  check monitor names in hypr/hyprland.lua"
echo "  reboot"
