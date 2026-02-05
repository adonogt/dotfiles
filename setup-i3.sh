#!/usr/bin/env bash
set -e

# colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[info]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[warn]${NC} $1"
}

log_error() {
    echo -e "${RED}[error]${NC} $1"
}

# update system packages
log_info "updating system..."
sudo pacman -Syu --noconfirm

# install base packages from official repositories
log_info "installing packages via pacman..."
sudo pacman -S --noconfirm --needed \
    base-devel \
    git \
    curl \
    wget \
    openssh \
    ripgrep \
    zip \
    unzip \
    p7zip \
    btop \
    fastfetch \
    udiskie \
    kitty \
    rofi \
    thunar \
    thunar-archive-plugin \
    file-roller \
    network-manager-applet \
    bluez \
    bluez-utils \
    blueman \
    pipewire \
    wireplumber \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    pavucontrol \
    dunst \
    feh \
    picom \
    polybar \
    flameshot \
    clipmenu \
    brightnessctl \
    zathura \
    zathura-pdf-mupdf \
    imv \
    mpv \
    firefox \
    fcitx5 \
    fcitx5-mozc \
    fcitx5-configtool \
    neovim \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ttf-jetbrains-mono-nerd \
    i3lock-color \
    tmux \
    jdk-openjdk \
    maven \
    docker \
    docker-compose \
    postgresql \
    dbeaver \
    postman-bin

# enable system services
log_info "enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now docker

# add user to docker group
log_info "adding user to docker group..."
sudo usermod -aG docker $USER

# install yay aur helper if not already installed
log_info "installing yay..."
if ! command -v yay &>/dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    log_warn "yay already installed, skipping..."
fi

# install aur packages
log_info "installing packages via yay..."
yay -S --noconfirm --needed \
    anki-bin \
    obsidian \
    bitwarden \
    intellij-idea-community-edition \
    visual-studio-code-bin \
    slack-desktop \
    discord \
    aws-cli-v2

# configure fcitx5 environment variables in .profile
log_info "configuring fcitx5 environment variables..."
PROFILE_FILE="$HOME/.profile"

if ! grep -q "fcitx" "$PROFILE_FILE" 2>/dev/null; then
    cat << 'EOF' >> "$PROFILE_FILE"

# fcitx5 input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
    log_info "fcitx5 variables added to .profile"
else
    log_warn "fcitx5 variables already exist in .profile"
fi

# add fcitx5 to i3 config if not already there
I3_CONFIG="$HOME/.config/i3/config"
if [ -f "$I3_CONFIG" ] && ! grep -q "fcitx5" "$I3_CONFIG"; then
    log_info "adding fcitx5 autostart to i3 config..."
    echo "" >> "$I3_CONFIG"
    echo "# autostart fcitx5" >> "$I3_CONFIG"
    echo "exec --no-startup-id fcitx5 -d" >> "$I3_CONFIG"
fi

# configure git (optional - customize with your info)
log_info "configuring git..."
read -p "enter your git username (or press enter to skip): " git_user
read -p "enter your git email (or press enter to skip): " git_email

if [ -n "$git_user" ]; then
    git config --global user.name "$git_user"
fi

if [ -n "$git_email" ]; then
    git config --global user.email "$git_email"
fi

# install sdkman for managing java versions and spring boot cli
log_info "installing sdkman..."
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    log_info "installing spring boot cli via sdkman..."
    sdk install springboot
else
    log_warn "sdkman already installed, skipping..."
fi

log_info "installation completed!"
echo ""
log_warn "important notes:"
echo "  1. reboot the system to apply all changes"
echo "  2. after reboot, logout and login again for docker group to take effect"
echo "  3. configure fcitx5: run 'fcitx5-configtool' and add 'mozc'"
echo "  4. sdkman installed - restart terminal and run 'sdk version' to verify"
echo ""
log_info "development tools installed:"
echo "  - java (openjdk)"
echo "  - maven"
echo "  - intellij idea community"
echo "  - vscode"
echo "  - docker & docker-compose"
echo "  - postgresql"
echo "  - dbeaver (database gui)"
echo "  - postman (api testing)"
echo "  - aws cli v2"
echo "  - sdkman (java version manager)"
echo "  - spring boot cli (via sdkman)"
echo ""
