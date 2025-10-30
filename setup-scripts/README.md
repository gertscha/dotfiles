# The scripts
These scripts install the apps that are configured with the respective
stow package. The nerdfonts script is standalone.

All the install scripts assume a Debian based distribution.

`basic.sh` is assumed to have been run before any other scripts.

# Desktop apps from Appimages
See the example file in this folder.

Icons got into `.local/share/icons`,
then only specify the file name without extension.

Appimages can go anywhere (give path in .desktop),
usually they go into `.local/share/` or to `/opt/` in a dedicated folder.
The .desktop file goes into `.local/share/applications/`
The exec value needs to be the absolute path.

Use `desktop-file-validate` to check the file.

There are also tools to automate this, for example
[AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher) or
[AM](https://github.com/ivan-hc/AM).
There are also flatpaks to handle the management, for example
[Gear Lever](https://flathub.org/apps/it.mijorus.gearlever).

# KVM/QEMU
There are still some issues regarding the polkit.
The password prompt does not appear. Some apps fail to launch, some
produce errors since they fail to authenticate.
To fix this for virt-manager add it to the proper groups:
```
sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G kvm $(whoami)
```

# Neovim
The script `neovim.sh` performs a build from source and loads the configuration
with `stow`.

A helper update script `update-nvim.sh` is also available. First update the
local neovim repository to the commit/tag/branch you want and then run the
script to uninstall the current version and build Neovim again.

For more information about building Neovim see
[upstream](https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source).
