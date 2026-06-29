#!/bin/bash

set -e

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

retry_command() {
  local command="$1"
  local max_retries=10
  local retry_delay=5
  local attempt=0
  local exit_status

  while true; do
    eval "$command"
    exit_status=$?

    if [ "$exit_status" -eq 0 ]; then
      break
    fi

    attempt=$((attempt + 1))

    if [ "$attempt" -ge "$max_retries" ]; then
      echo "Command failed after $max_retries attempts."
      return 1
    fi

    echo "Command failed. Retrying in $retry_delay seconds... (Attempt $attempt/$max_retries)"
    sleep "$retry_delay"
  done

  return 0
}

# ---------------------------------------------------------------------------
# Installers
# ---------------------------------------------------------------------------

install_zsh() {
  echo "Installing Zsh and dependencies..."
  sudo pacman -S --needed --noconfirm zsh git curl

  echo "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Zsh installed successfully!"
}

install_yay() {
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git
  pushd yay
  makepkg -si --noconfirm
  popd
  rm -rf yay
  echo "yay has been installed successfully!"
}

install_pyenv() {
  echo "Installing pyenv..."
  curl https://pyenv.run | bash
  echo "pyenv installed successfully!"
}

install_nvm() {
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
  echo "nvm installed successfully!"
}

install_rust() {
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  echo "Rust installed successfully!"
}

install_essential_packages() {
  echo "Installing essential packages..."

  yay -S --noconfirm --needed \
    adb \
    adw-gtk-theme \
    age \
    alacritty \
    aspnet-runtime \
    audacity \
    axel \
    bat \
    bitwarden \
    btop \
    calc \
    calibre-bin \
    cava \
    chromium \
    dart-sass \
    dbeaver \
    ddcutil \
    dms-shell-niri \
    docker \
    docker-buildx \
    docker-compose \
    dotnet-sdk \
    dotnet-sdk-8.0 \
    easyeffects \
    ente-auth-bin \
    fastfetch \
    fd \
    ffmpeg \
    firefox \
    fzf \
    gtk3 \
    git \
    glow \
    go \
    grim \
    hugo \
    imv \
    inkscape \
    iwd \
    light \
    jdk-openjdk \
    kolourpaint \
    man \
    matugen \
    mugshot \
    mpv \
    ncdu \
    niri \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ntfs-3g \
    obs-studio \
    openssh \
    otf-font-awesome \
    pavucontrol \
    pipewire \
    pipewire-alsa \
    pipewire-audio \
    pipewire-jack \
    pipewire-pulse \
    polkit-gnome \
    python-gobject \
    qemu-full \
    qt5ct \
    qt6-multimedia-ffmpeg \
    qt6-wayland \
    qt6ct \
    reflector \
    ripgrep \
    samba \
    seafile-client \
    shfmt \
    sqlitebrowser \
    swappy \
    thunderbird \
    thunar \
    tree \
    ttf-font-awesome \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-roboto \
    ttf-roboto-serif \
    udisks2 \
    unzip \
    util-linux \
    vim \
    virt-manager \
    visual-studio-code-bin \
    wget \
    xdg-desktop-portal \
    xdg-desktop-portal-wlr \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    xorg-xwayland \
    xwayland-satellite \
    xz \
    zed \
    zip \
    zram-generator

  echo "Essential packages installed successfully!"
}

# ---------------------------------------------------------------------------
# Directory / file setup
# ---------------------------------------------------------------------------

create_essential_directories() {
  echo "Creating essential directories..."
  mkdir -p ~/os
  mkdir -p ~/repos
  mkdir -p ~/screenshots
  mkdir -p ~/sync
  mkdir -p ~/vms
  mkdir -p ~/wallpapers
  echo "Essential directories created successfully!"
}

copy_root_files() {
  echo "Copying root directory contents to system root..."
  sudo cp -r root/. /
  echo "Root directory contents copied successfully!"
}

copy_home_files() {
  echo "Copying home directory contents..."
  cp -r home/. ~/
  chmod +x ~/.scripts/start-docker
  chmod +x ~/.scripts/start-libvirt
  echo "Home directory contents copied successfully!"
}

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

configure_user_dirs() {
  local user_dirs_file="$HOME/.config/user-dirs.dirs"

  echo "Configuring XDG user directories..."

  mkdir -p "$(dirname "$user_dirs_file")"

  cat >"$user_dirs_file" <<EOF
# This file is written by xdg-user-dirs-update
# If you want to change or add directories, just edit the line you're
# interested in. All local changes will be retained on the next run.
# Format is XDG_xxx_DIR="\$HOME/yyy", where yyy is a shell-escaped
# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
# absolute path. No other format is supported.
# 
XDG_DESKTOP_DIR="$HOME"
XDG_DOWNLOAD_DIR="$HOME"
XDG_TEMPLATES_DIR="$HOME"
XDG_PUBLICSHARE_DIR="$HOME"
XDG_DOCUMENTS_DIR="$HOME"
XDG_MUSIC_DIR="$HOME"
XDG_PICTURES_DIR="$HOME"
XDG_VIDEOS_DIR="$HOME"
XDG_PROJECTS_DIR="$HOME"
EOF

  echo "XDG user directories configured successfully!"
}

configure_zsh() {
  echo "Defining plugin and theme path..."
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  echo "Installing Zsh plugins and themes..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"

  echo "Zsh plugins and themes installed successfully!"
}

configure_samba() {
  echo "Configuring Samba..."

  if ! getent group smbusers >/dev/null 2>&1; then
    echo "Creating smbusers group..."
    sudo groupadd smbusers
  else
    echo "smbusers group already exists."
  fi

  echo "Adding user to smbusers group..."
  sudo usermod -aG smbusers "$USER"

  echo "Setting Samba password for $USER..."
  if echo -e "$samba_password\n$samba_password" | sudo smbpasswd -a "$USER"; then
    echo "Samba password set successfully!"
  else
    echo "Failed to set Samba password!" >&2
    exit 1
  fi

  echo "Adding Samba profile..."
  sudo tee -a /etc/samba/smb.conf >/dev/null <<EOF

[$USER]
path = /home/$USER
read only = no
browseable = yes
valid users = @smbusers
create mask = 0770
directory mask = 0770
EOF

  echo "Restarting Samba..."
  sudo systemctl restart smb.service 2>/dev/null || sudo systemctl restart smbd.service

  echo "Samba configured successfully!"
}

configure_git() {
  echo "Configuring Git..."

  git config --global user.name "$git_username"
  git config --global user.email "$git_email"
  git config --global core.editor "$git_editor"

  echo "Git configuration updated:"
  echo "  user.name:    $(git config --global user.name)"
  echo "  user.email:   $(git config --global user.email)"
  echo "  core.editor:  $(git config --global core.editor)"

  echo "Git configured successfully!"
}

configure_docker() {
  echo "Configuring Docker..."

  if id -nG "$USER" | grep -qw "docker"; then
    echo "$USER is already a member of the docker group."
  else
    sudo usermod -aG docker "$USER"
    echo "$USER added to docker group."
  fi

  echo "Docker configured successfully!"
}

configure_dotnet() {
  echo "Installing dotnet-ef tool..."
  dotnet tool install --global dotnet-ef

  echo "Installing csharprepl tool..."
  dotnet tool install --global csharprepl

  echo "Installing Avalonia template..."
  dotnet new install Avalonia.Templates

  echo "Global dotnet tools and templates installed successfully!"
}

configure_python() {
  echo "Installing Python 3.12.7 from pyenv..."
  zsh -c "source ~/.zshrc && pyenv install 3.12.7 && pyenv global 3.12.7" || echo "Python installation failed"
  echo "Python 3.12.7 installed successfully!"
}

configure_node_js() {
  echo "Installing Node.js LTS from nvm..."
  zsh -c "source ~/.zshrc && nvm install --lts && nvm use --lts" || echo "Node.js LTS installation failed"
  echo "Node.js LTS installed successfully!"
}

configure_services() {
  echo "Setting up ssh-agent service..."
  if systemctl --user enable --now ssh-agent; then
    echo "ssh-agent service started successfully."
  else
    echo "Failed to start ssh-agent service."
  fi

  echo "Setting up udisks2 service..."
  if sudo systemctl enable --now udisks2; then
    echo "udisks2 service started successfully."
  else
    echo "Failed to start udisks2 service."
  fi

  echo "Setting up niri and dms..."
  if systemctl --user add-wants niri.service dms; then
    echo "niri and dms services started successfully."
  else
    echo "Failed to start niri and dms services."
  fi

  echo "Service setup complete. If any issues occurred, please review the error messages above."
}

configure_dms() {
  echo "Installing dms plugins..."
  retry_command "dms plugins install catWidget"
  retry_command "dms plugins install colorPickerDms"
  echo "dms plugins installed successfully!"

  echo "Installing dms greeter..."
  retry_command "dms greeter install -y"
  echo "dms greeter installed successfully!"
}

configure_light() {
  echo "Configuring light..."

  if id -nG "$USER" | grep -qw "video"; then
    echo "$USER is already a member of the video group."
  else
    sudo usermod -aG video "$USER"
    echo "$USER added to video group."
  fi

  echo "Light configured successfully!"
}

configure_vscode() {
  echo "Installing Visual Studio Code extensions..."

  local extensions=(
    anweber.vscode-httpyac
    avaloniateam.vscode-avalonia
    bradlc.vscode-tailwindcss
    codeium.codeium
    devsense.phptools-vscode
    editorconfig.editorconfig
    esbenp.prettier-vscode
    fcrespo82.markdown-table-formatter
    formulahendry.auto-close-tag
    formulahendry.auto-rename-tag
    george-alisson.html-preview-vscode
    golang.go
    gruntfuggly.todo-tree
    hediet.vscode-drawio
    irongeek.vscode-env
    lakshits11.best-themes-redefined
    matthewpi.caddyfile-support
    miguelsolorio.symbols
    mkhl.shfmt
    ms-dotnettools.csharp
    ms-dotnettools.vscode-dotnet-runtime
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-python.vscode-python-envs
    perkovec.emoji
    qwtel.sqlite-viewer
    redhat.vscode-yaml
    renesaarsoo.sql-formatter-vsc
    rogalmic.vscode-xml-complete
    shd101wyy.markdown-preview-enhanced
    sissel.shopify-liquid
    sleistner.vscode-fileutils
    tamasfe.even-better-toml
    yinz.safira
  )

  for ext in "${extensions[@]}"; do
    retry_command "code --install-extension $ext"
  done

  echo "Visual Studio Code extensions installed successfully!"
}

cleanup() {
  echo "Cleaning cache..."
  sudo rm -rf ~/.cache/* || true

  echo "Cleaning go config..."
  rm -rf ~/.config/go || true

  echo "Cleaning desktop entries..."
  if ! .bin/clean-desktop; then
    echo "Failed to clean desktop entries"
  fi

  echo "Cleaning up AUR packages and cache..."
  yay -Yc --noconfirm || true
  yay -Sc --noconfirm || true

  echo "Cleaning up temporary files..."
  sudo rm -rf /tmp/* || true
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

echo "Enter Git user name:"
read -r git_username

echo "Enter Git email address:"
read -r git_email

echo "Enter Git preferred text editor (e.g., vim, nano, code):"
read -r git_editor

echo "Enter a Samba password for $USER:"
read -rs samba_password
echo # newline after silent read

echo "Updating system..."
sudo pacman -Syu --noconfirm

install_zsh
install_yay
install_pyenv
install_nvm
install_rust
install_essential_packages

create_essential_directories

copy_root_files
copy_home_files

configure_user_dirs
configure_zsh
configure_samba
configure_git
configure_docker
configure_dotnet
configure_python
configure_node_js
configure_services
configure_dms
configure_light
configure_vscode

cleanup
echo "Installation complete!"
