# arch-sway

A collection of configuration files for Arch Linux (minimal install) and Sway as the window manager.

## Installation

The installation script is intended for a fresh Arch Linux installation only. It will install and configure a range of software and settings.

Note that the script installs `Oh My Zsh`, which may change the default shell to `zsh`. After installation, type `exit` to return to `bash` and continue with the rest of the process.

1. Clone the repository and navigate to the installation directory:

    ```shell
    git clone https://github.com/luthfiampas/dotconfig && \
    cd dotconfig/arch-sway
    ```

2. Run the installation script:

    ```shell
    ./_install.sh
    ```

3. Once the script finishes, reboot the system.

## Additional Steps

### Install `Firefox-UI-Fix`

Apply the `photon` UI style to Firefox.

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)"
```

### Install Python and Node.js

Install Python and Node.js using `pyenv` and `nvm`.

```shell
pyenv install <version>
pyenv global <version>

nvm install <version>
nvm use <version>
```
