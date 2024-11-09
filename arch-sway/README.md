# arch-sway

A collection of configuration files for Arch Linux (minimal install) and Sway as the window manager.

## Installation

To set up the system, use the provided installation script. Note that the script will install [`Oh My Zsh`](https://github.com/ohmyzsh/ohmyzsh), which may change the default shell to `zsh` during installation. After the installation of `Oh My Zsh` completes, type `exit` to return to `bash` and continue the rest of the installation process.

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

The `light` program used for adjusting brightness requires write permissions to the `/sys/class/backlight/*/brightness` file. By default, only `root` can change the brightness by this method. To grant access, add the user to the `video` group.

```shell
sudo usermod -aG video <user>
```

## Configure Samba

```shell
sudo groupadd smbusers
sudo usermod -aG smbusers <user>
sudo smbpasswd -a <user>
```
