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
noto-fonts-emoji \
noto-fonts-cjk \
iwd \
zip \
unzip \
vim \
ncdu \
zsh \
fzf \
bat \
btop \
ntfs-3g \
glow \
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
fastfetch \
calc \
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
docker \
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

# Copy necessary files to root
echo "Copying necessary files to root..."
sudo cp root/etc/resolv.conf /etc/resolv.conf
sudo mkdir -p /etc/systemd
sudo cp root/etc/systemd/resolved.conf /etc/systemd/resolved.conf
sudo mkdir -p /etc/dnscrypt-proxy
sudo cp root/etc/dnscrypt-proxy/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
sudo mkdir -p /etc/samba
sudo cp root/etc/samba/smb.conf /etc/samba/smb.conf
sudo mkdir -p /boot/loader
sudo cp root/boot/loader/loader.conf /boot/loader/loader.conf
sudo cp root/usr/share/applications/firefox-private.desktop /usr/share/applications/firefox-private.desktop

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

# Copy SSH config file
echo "Copying SSH config file..."
mkdir -p ~/.ssh && cp .ssh/config ~/.ssh/.

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
cp -r .config/btop ~/.config/.
cp -r .config/glow ~/.config/.
cp .config/user-dirs.dirs ~/.config/.

# Create and start ssh-agent service
echo "Setting up ssh-agent service..."
systemctl --user enable --now ssh-agent

# Install commonly used VSCode extensions
echo "Installing VSCode extensions..."
code --install-extension codeium.codeium && \
code --install-extension devsense.phptools-vscode && \
code --install-extension eamodio.gitlens && \
code --install-extension editorconfig.editorconfig && \
code --install-extension esbenp.prettier-vscode && \
code --install-extension fcrespo82.markdown-table-formatter && \
code --install-extension gruntfuggly.todo-tree && \
code --install-extension hediet.vscode-drawio && \
code --install-extension miguelsolorio.symbols && \
code --install-extension ms-dotnettools.csharp && \
code --install-extension redhat.vscode-yaml && \
code --install-extension rogalmic.vscode-xml-complete && \
code --install-extension shd101wyy.markdown-preview-enhanced && \
code --install-extension sissel.shopify-liquid && \
code --install-extension sleistner.vscode-fileutils && \
code --install-extension tamasfe.even-better-toml

# Configure samba
echo "Configuring samba..."
sudo groupadd smbusers
sudo usermod -aG smbusers $USER
sudo smbpasswd -a $USER

# Configure light
echo "Configuring light..."
sudo usermod -aG video $USER

# Configure docker
echo "Configuring docker..."
sudo usermod -aG docker $USER

# Install global dotnet tools
echo "Installing global dotnet tools..."
dotnet tool install --global dotnet-ef
dotnet tool install --global csharprepl

# Install dotnet templates
echo "Installing dotnet templates..."
dotnet new install Avalonia.Templates

# Configure git: prompt for user.name
echo "Please enter your Git user name:"
read git_username
git config --global user.name "$git_username"

# Configure git: prompt for user.email
echo "Please enter your Git email address:"
read git_email
git config --global user.email "$git_email"

# Configure git: prompt for core.editor
echo "Please enter your preferred text editor for Git (e.g., vim, nano, code):"
read git_editor
git config --global core.editor "$git_editor"

# Configure git: confirmation
echo "Git configuration updated:"
echo "user.name: $(git config --global user.name)"
echo "user.email: $(git config --global user.email)"
echo "core.editor: $(git config --global core.editor)"

# Clean cache
echo "Cleaning cache..."
sudo rm -rf ~/.cache/*

# Perform clean-desktop
echo "Cleaning desktop..."
.bin/clean-desktop

# Clean up AUR packages and cache
echo "Cleaning up AUR packages and cache..."
yay -Yc --noconfirm
yay -Sc --noconfirm

echo "Installation complete!"
