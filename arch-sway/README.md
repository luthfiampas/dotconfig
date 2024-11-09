# arch-sway

A collection of configuration files for Arch Linux (minimal install) and Sway as the window manager.

## Installation

To set up the system, use the provided installation script. Note that the script installs `Oh My Zsh`, which may change the default shell to `zsh` during installation. After the installation of `Oh My Zsh` completes, type `exit` to return to `bash` and continue with the rest of the installation.

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

## Set up `lutlight`

The `light` program used to adjust brightness requires write permissions to the `/sys/class/backlight/*/brightness` file. By default, only `root` can change the brightness. To grant access, add user to the `video` group:

```shell
sudo usermod -aG video <user>
```

## Configure `Samba`

To enable file sharing with `Samba`, add user to the `smbusers` group and set a `Samba` password for authentication:

```shell
sudo groupadd smbusers
sudo usermod -aG smbusers <user>
sudo smbpasswd -a <user>
```

## Install `Firefox-UI-Fix`

Install the `Firefox-UI-Fix` script to apply the `photon` UI style:

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)"
```
