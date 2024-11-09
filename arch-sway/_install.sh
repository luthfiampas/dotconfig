#!/bin/bash

# Exit the script on error (for the critical parts)
set -e

# Perform system update
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install yay (AUR helper)
echo "Installing yay (AUR helper)..."
sudo pacman -S --needed git base-devel && \
git clone https://aur.archlinux.org/yay.git && \
cd yay && \
makepkg -si --noconfirm && \
cd .. && \
rm -rf yay

# Clean-up unnecessary files (recheck before deletion)
echo "Cleaning up unnecessary files..."
rm -rf ~/.config/go

# Install pyenv
echo "Installing pyenv..."
curl https://pyenv.run | bash

# Install nvm
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Install initial packages from AUR and official repositories
echo "Installing initial packages..."
yay -S --noconfirm --needed \
ttf-roboto \
ttf-roboto-serif \
ttf-jetbrains-mono \
ttf-jetbrains-mono-nerd \
ttf-font-awesome \
iwd \
zip \
unzip \
vim \
ncdu \
zsh \
fzf \
bat \
htop \
openssh \
pipewire \
pipewire-audio \
pipewire-alsa \
pipewire-jack \
pipewire-pulse \
alacritty \
sway \
swaybg \
wofi \
waybar \
xorg-xwayland \
polkit-gnome \
xdg-desktop-portal \
xdg-desktop-portal-wlr \
light \
ddcutil \
grim \
slurp \
swappy \
imv \
mpv \
ffmpeg \
dnscrypt-proxy \
pavucontrol \
samba \
visual-studio-code-bin \
firefox \
dbeaver \
sqlitestudio-bin \
dotnet-sdk \
aspnet-runtime \
obs-studio \
qt6-wayland \
blender \
easyeffects \
qemu-full \
virt-manager

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Oh My Zsh plugins and themes
echo "Installing Zsh plugins and themes..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-bat

# Try to start dnscrypt-proxy and continue even if an error occurs
echo "Setting up dnscrypt-proxy service..."
sudo systemctl enable --now dnscrypt-proxy || true

# Build lutlight
echo "Building lutlight..."
mkdir -p ~/.bin
gcc -O2 -o ~/.bin/lutlight _src/lutlight/lutlight.c -lm

# Ensure ~/.bin exists before copying
echo "Copying bin files..."
mkdir -p ~/.bin
cp .bin/clean-desktop ~/.bin/. && chmod +x ~/.bin/clean-desktop

# Create commonly used directories
echo "Creating directories..."
sudo mkdir -p /data/pictures/wallpapers
sudo mkdir -p /data/repos/personal
sudo chmod 777 -R /data

# Copy wallpapers
echo "Copying wallpapers..."
cp root/data/pictures/wallpapers/* /data/pictures/wallpapers/.

# Copy config files in root
echo "Copying config files..."
sudo cp root/etc/resolv.conf /etc/resolv.conf
sudo mkdir -p /etc/systemd
sudo cp root/etc/systemd/resolved.conf /etc/systemd/resolved.conf
sudo mkdir -p /etc/dnscrypt-proxy
sudo cp root/etc/dnscrypt-proxy/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
sudo mkdir -p /etc/samba
sudo cp root/etc/samba/smb.conf /etc/samba/smb.conf
sudo mkdir -p /boot/loader
sudo cp root/boot/loader/loader.conf /boot/loader/loader.conf

# Copy dot files to home directory
echo "Copying dot files..."
cp .bash_profile ~/.
cp .bashrc ~/.
cp .dircolors ~/.
cp .gtkrc-2.0 ~/.
cp .p10k.zsh ~/.
cp .vimrc ~/.
cp .zprofile ~/.
cp .zshrc ~/.

# Copy .config files and directories
echo "Copying .config files..."
cp -r .config/alacritty ~/.config/.
cp -r .config/Code ~/.config/.
cp -r .config/fontconfig ~/.config/.
cp -r .config/gtk-2.0 ~/.config/.
cp -r .config/gtk-3.0 ~/.config/.
cp -r .config/gtk-4.0 ~/.config/.
cp -r .config/light ~/.config/.
cp -r .config/sway ~/.config/.
cp -r .config/systemd ~/.config/.
cp -r .config/waybar ~/.config/.
cp -r .config/wofi ~/.config/.
cp -r .config/xdg-desktop-portal ~/.config/.
cp .config/user-dirs.dirs ~/.config/.

# Create and start ssh-agent service
echo "Setting up ssh-agent service..."
systemctl --user enable --now ssh-agent

# Clean up AUR packages and cache
echo "Cleaning up AUR packages and cache..."
yay -Yc --noconfirm
yay -Sc --noconfirm

echo "Installation complete!"
