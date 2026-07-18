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
    grim slurp satty \
    thunar thunar-archive-plugin thunar-volman gvfs file-roller \
    unzip zip p7zip unrar \
    hyprsunset \
    git \
    ttf-jetbrains-mono-nerd noto-fonts-cjk \
    fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-mozc \
    sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg qt6-imageformats

step "aur packages..."

yay -S --needed --noconfirm otf-ipafont bluetui impala

# ── configs ───────────────────────────────────────────────────────────────────

step "configs..."

for app in hypr waybar kitty fuzzel mako; do
    mkdir -p "$HOME/.config/$app"
    cp -r "$DOTFILES/$app/"* "$HOME/.config/$app/"
done

chmod +x "$HOME/.config/hypr/scripts/monitor-hotplug.sh"
fc-cache -fv > /dev/null 2>&1

# ── sddm + silentsddm ─────────────────────────────────────────────────────────

step "sddm theme..."

git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM /tmp/SilentSDDM
sudo mkdir -p /usr/share/sddm/themes/silent
sudo cp -rf /tmp/SilentSDDM/. /usr/share/sddm/themes/silent/
sudo cp -r /tmp/SilentSDDM/fonts/* /usr/share/fonts/
rm -rf /tmp/SilentSDDM

# copy wallpaper into theme if it exists
WALLPAPER="$HOME/media/pictures/wallpapers/wallpaper.jpg"
if [ -f "$WALLPAPER" ]; then
    sudo cp "$WALLPAPER" /usr/share/sddm/themes/silent/backgrounds/wallpaper.jpg
    sudo sed -i 's|^background = "smoky.jpg"|background = "backgrounds/wallpaper.jpg"|' \
        /usr/share/sddm/themes/silent/configs/default.conf
    step "wallpaper copied"
else
    step "wallpaper not found — copy manually to /usr/share/sddm/themes/silent/backgrounds/"
fi

sudo tee /etc/sddm.conf > /dev/null << 'SDDM'
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
SDDM

# ── services ──────────────────────────────────────────────────────────────────

step "services..."

sudo systemctl enable sddm
sudo systemctl set-default graphical.target

# ── done ──────────────────────────────────────────────────────────────────────

echo ""
echo "done."
echo ""
echo "  open fcitx5-configtool and add mozc"
echo "  check monitor names in hypr/hyprland.lua"
echo "  reboot"
