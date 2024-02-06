# The scripts
These scripts install the apps that are configured with the respective
stow package. The nerdfonts script is standalone.

`basic.sh` is assumed to have been run before any other scripts.

# Desktop apps from Appimages
See the example file in this folder.

Icons got into `.local/share/icons`,
then only specify the file name without extension.

Appimages can go anywhere (give path in .desktop),
usually they go into `.local/share/` in a dedicated folder.
The .desktop file goes into `.local/share/applications/`
The exec value needs to be the absolute path.

Use `desktop-file-validate` to check the file.

There are also tools to automate this, for example
[AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher).

