# Configuration Management
This is how I manage my configuration files.

Using GNU Stow is a simple way to manage all files in a single repository
while simultaneously having fine control over the installations.

See `man stow` for a full explanation of GNU Stow.

## Using Stow
Install the stow with the package manager of your system.

Folders represent packages (except for scripts).

Stow creates symlinks in the target directory based on
the structure inside the package.
By default this happens in the parent directory.
```
stow [package] # create symlinks
stow -D [package] # remove created symlinks
stow -R [package] # restow, first remove all, then add back
```
Cloning this repo into the home directory and then running
the stow commands inside the dotfiles folder generates the
symlinks in the correct locations.

## Windows
On Windows I use `mklink` to manually create the symbolic link for Neovim.
```
mklink /j "C:\Users\#username\AppData\Local\nvim" "D:\#path_to_repository\neovim\.config\nvim"
```
This creates a [Junction](https://learn.microsoft.com/en-us/windows/win32/fileio/hard-links-and-junctions#junctions)
which can go to other volumes.


# Packages
Overview for the various "packages" I have.

## Basic
This covers the basics, meaning shells (bash, zsh and fish), tmux, lf, gitconfig
and the foot terminal.

## Alacritty
My Alacritty setup, not in basic since I want to use it on Windows.

## KDE
This just configures `ksshaskpass`, to allow it to be used to store SSH keys
in a KDE Plamsa desktop (usually you also need to install it).

## Neovim
See the README inside `neovim/.config/nvim/`

## Niri
The Wayland Compositor. This is my second DE free setup. Niri is great for
big multitasking on a desktop. Its scrolling tiling works very well with
my workflows. Unlike something like Sway which is great for a laptop but I
don't want to use on my desktop.

### Setup
See the [Getting Started](https://github.com/YaLTeR/niri/wiki/Getting-Started)
and [required software](https://github.com/YaLTeR/niri/wiki/Important-Software).

I am using Niri on top of Fedora KDE Plasma (its a good idea to have a fallback
DE on the system). So here is how I did it for my system:

#### TLDR (Fedora):
```
sudo dnf install niri waybar swaybg swayidle wlogout wlsunset sway-notification-center
```
The other dependencies should be covered by this. But you can check that these
are installed: `xdg-desktop-portal-gtk`, `xdg-desktop-portal-gnome`,
`polkit-kde` and `xwayland-satellite`.

Because Niri uses the Gnome portal, the file picker dialogue requires Nautilus.
So it needs to be installed, `sudo dnf install nautilus`.

I am considering adding:
- `mpv-mpris`
- `swww`

> [!NOTE]
> manual build of `swww`, it requires `lz4-devel` (and `wayland-protocols-devel`,
> not verified by me). Also see build
> [intructions](https://github.com/LGFae/swww?tab=readme-ov-file#build)
> for swww. (some early experiments give bad overhead results, need more
> testing)

Mako notifier is also configured, but the systemd link is not done and it
should not be installed if you have sway-notification-center.

#### Systemd
You can either launch services with `spawn-at-startup` in the Niri config, or
use systemd. Systemd has better recovery on crashes and some other benefits.
Setup is easy if .service is already provided but also easy to write yourself,
see [example setup](https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup).
The symlinks should be restored with Stow.

#### Paths
Some files specify image paths, adjust them to images of your liking.
Files: `niri/config.kdl`, `swaylock/config` (also grep for ~/Pictures).


## Sway
I set this up for my Debian 12 Laptop. The base/fallback DE is Gnome.
This works decently for me, I would not use it on a Desktop though.
The tiling nature can be constricting if you are someone that has dozens of
windows open.

My setup does not handle the keyring properly. SSH keys and some logins (for
example Nextcloud) require authorization every time the system boots.
I have not bothered fixing this, since I always hibernate my device (keyrings
are an absolute pain to handle in compositor only setups, if there is an easy
trick please bless me with the knowledge).

There is an install script that should cover the required packages, see
`scripts/debian/sway-install.sh`.

