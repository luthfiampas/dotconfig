#!/bin/bash

set -e

retry_command() {
    local command="$1"
    local max_retries=10
    local retry_delay=5
    local attempt=0
    local exit_status

    while true; do
        eval "$command"
        exit_status=$?

        if [ $exit_status -eq 0 ]; then
            break
        fi

        attempt=$((attempt + 1))

        if [ $attempt -ge $max_retries ]; then
            echo "Command failed after $max_retries attempts."
            return 1
        fi

        echo "Command failed. Retrying in $retry_delay seconds... (Attempt $attempt/$max_retries)"
        sleep $retry_delay
    done

    return 0
}

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
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    echo "nvm installed successfully!"
}

install_lutlight() {
    echo "Building lutlight..."
    mkdir -p ~/.bin
    gcc -O2 -o ~/.bin/lutlight _src/lutlight/lutlight.c -lm
    echo "lutlight built successfully and saved to ~/.bin/lutlight."
}

install_essential_packages() {
    echo "Installing essential packages..."

    yay -S --noconfirm --needed \
        alacritty \
        aspnet-runtime \
        bat \
        blender \
        btop \
        calc \
        dart-sass \
        dbeaver \
        ddcutil \
        dnscrypt-proxy \
        dnsmasq \
        docker \
        docker-compose \
        dotnet-sdk \
        easyeffects \
        fastfetch \
        ffmpeg \
        firefox \
        fzf \
        git \
        glow \
        go \
        grim \
        hugo \
        imv \
        iwd \
        light \
        man \
        mpv \
        ncdu \
        noto-fonts-cjk \
        noto-fonts-emoji \
        ntfs-3g \
        obs-studio \
        openssh \
        pavucontrol \
        pipewire \
        pipewire-alsa \
        pipewire-audio \
        pipewire-jack \
        pipewire-pulse \
        polkit-gnome \
        qemu-full \
        qt6-wayland \
        samba \
        slurp \
        sqlitestudio-bin \
        swappy \
        sway \
        swaybg \
        ttf-font-awesome \
        ttf-jetbrains-mono \
        ttf-jetbrains-mono-nerd \
        ttf-roboto \
        ttf-roboto-serif \
        unzip \
        vim \
        virt-manager \
        visual-studio-code-bin \
        waybar \
        wofi \
        xdg-desktop-portal \
        xdg-desktop-portal-wlr \
        xorg-xwayland \
        zip

    echo "Essential packages installed successfully!"
}

make_essential_directories() {
    echo "Creating essential directories..."

    sudo mkdir -p /data/pictures/wallpapers
    sudo mkdir -p /data/repos/personal
    sudo mkdir -p /data/repos/client
    sudo mkdir -p /mnt/1
    sudo mkdir -p /mnt/2
    sudo mkdir -p /mnt/3

    sudo chmod 777 -R /data
    sudo chmod 777 -R /mnt/1
    sudo chmod 777 -R /mnt/2
    sudo chmod 777 -R /mnt/3

    echo "Essential directories created successfully!"
}

copy_root() {
    echo "Copying root folder contents to system root..."
    sudo cp -r root/. /
    echo "Root contents copied successfully!"
}

copy_dotconfig() {
    echo "Copying .config directory..."
    mkdir -p ~/.config
    cp -r .config/. ~/.config/
    echo ".config directory copied successfully!"
}

copy_dotfiles() {
    echo "Copying dot files..."
    cp .bash_profile ~/.
    cp .bashrc ~/.
    cp .dircolors ~/.
    cp .gtkrc-2.0 ~/.
    cp .p10k.zsh ~/.
    cp .vimrc ~/.
    cp .zshrc ~/.
    cp .zprofile ~/.
    echo "Dot files copied successfully!"
}

copy_bin_files() {
    echo "Copying bin files..."
    mkdir -p ~/.bin
    cp -r .bin/. ~/.bin/
    chmod +x ~/.bin/clean-desktop
    echo "Bin files copied!"
}

copy_ssh_config() {
    echo "Copying SSH config file..."
    mkdir -p ~/.ssh

    cp .ssh/config ~/.ssh/
    chmod 600 ~/.ssh/config

    echo "SSH config file copied successfully!"
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

configure_vim() {
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo "Copying .vimrc..."
    cp .vimrc ~/.

    echo "Installing vim plugins..."
    vim -E -s -c 'set nocompatible' -c 'source ~/.vimrc' -c 'PlugInstall' -c 'qa' || true
    echo "Vim plugins installed successfully!"
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

    echo "Samba configured successfully!"
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

configure_git() {
    echo "Configuring Git..."

    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global core.editor "$git_editor"

    echo "Git configuration updated:"
    echo "user.name: $(git config --global user.name)"
    echo "user.email: $(git config --global user.email)"
    echo "core.editor: $(git config --global core.editor)"

    echo "Git configured successfully!"
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

configure_vs_code() {
    echo "Installing Visual Studio Code extensions..."

    retry_command "code --install-extension codeium.codeium"
    retry_command "code --install-extension devsense.phptools-vscode"
    retry_command "code --install-extension eamodio.gitlens"
    retry_command "code --install-extension editorconfig.editorconfig"
    retry_command "code --install-extension esbenp.prettier-vscode"
    retry_command "code --install-extension fcrespo82.markdown-table-formatter"
    retry_command "code --install-extension foxundermoon.shell-format"
    retry_command "code --install-extension gruntfuggly.todo-tree"
    retry_command "code --install-extension hediet.vscode-drawio"
    retry_command "code --install-extension miguelsolorio.symbols"
    retry_command "code --install-extension ms-dotnettools.csharp@2.45.25"
    retry_command "code --install-extension redhat.vscode-yaml"
    retry_command "code --install-extension rogalmic.vscode-xml-complete"
    retry_command "code --install-extension shd101wyy.markdown-preview-enhanced"
    retry_command "code --install-extension sissel.shopify-liquid"
    retry_command "code --install-extension sleistner.vscode-fileutils"
    retry_command "code --install-extension tamasfe.even-better-toml"
    retry_command "code --install-extension yinz.safira"

    echo "Visual Studio Code configured successfully!"
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
    echo "Setting up dnscrypt-proxy service..."
    if sudo systemctl enable --now dnscrypt-proxy; then
        echo "dnscrypt-proxy service started successfully."
    else
        echo "Failed to start dnscrypt-proxy service, but continuing..."
    fi

    echo "Setting up ssh-agent service..."
    if systemctl --user enable --now ssh-agent; then
        echo "ssh-agent service started successfully."
    else
        echo "Failed to start ssh-agent service."
    fi

    echo "Service setup complete. If any issues occurred, please review the error messages above."
}

clean_up() {
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

echo "Enter Git user name:"
read git_username

echo "Enter Git email address:"
read git_email

echo "Enter Git preferred text editor (e.g., vim, nano, code):"
read git_editor

echo "Enter a Samba password for $USER:"
read -s samba_password

echo "Updating system..."
sudo pacman -Syu --noconfirm

install_zsh
install_yay
install_pyenv
install_nvm
install_lutlight
install_essential_packages

make_essential_directories
copy_root
copy_dotconfig
copy_dotfiles
copy_bin_files
copy_ssh_config

configure_zsh
configure_vim
configure_samba
configure_docker
configure_light
configure_git
configure_dotnet
configure_vs_code
configure_python
configure_node_js
configure_services

clean_up
echo "Installation complete!"
