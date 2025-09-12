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
stow --dotfiles [package] # create symlinks
stow --dotfiles -D [package] # remove created symlinks
stow --dotfiles -R [package] # restow, first remove all, then add back
```
Cloning this repo into the home directory and then running
the stow commands inside the dotfiles folder generates the
symlinks in the correct locations.
The `--dotfiles` is necessary to expand the `dot-` prefix of the files.
My shells have this aliased so it is only needed for the initial setup.

I have encountered a bug with the `--dotfiles` option in version `stow` 2.3
that was fixed with version 2.4.

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
This covers the basics, meaning shells (bash, zsh and fish), `tmux`, `lf`,
`gitconfig` and the foot terminal.

`lf` is built from source (very simple since it uses `go`). The `go` binary
output path (`~/go/bin`) is already added to path in my shells.

I use [miniforge](https://github.com/conda-forge/miniforge), with this setup:
```
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh``
cd ~/.conda
ln -s <path to install>/miniforge3/bin/conda .
```
where I specify a custom install directory (usually `~/build`, or `~/build_sys`),
and symlink it in `.conda` to keep my shell aliases simple.

## Music
I use `mpd` with the `rmpc` front-end (with `cava`). All the mpd data is in
`~/Music`. I typically install `mpd` and `mpc` and I build `rmpc` from source
(easy `cargo build`, don't forget to add it to the path, I add all such binaries
to my `~/build_sys/install/bin/` folder).

Setup `mpd`:
```
systemctl --user enable --now mpd
```

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
The other core dependencies should be covered by this. But you can check that
these are installed: `xdg-desktop-portal-gtk`, `xdg-desktop-portal-gnome`,
`polkit-kde` and `xwayland-satellite`.

To get `mpd` integration in waybar I use
[mpdris2-rs](https://github.com/szclsya/mpdris2-rs). I build it from source.
the systemd service is setup to expect the `mpdris2-rs` binary in path (bash).

Because Niri uses the Gnome portal, the file picker dialogue requires Nautilus.
So it needs to be installed, `sudo dnf install nautilus`.

Mako notifier is also configured, but the systemd link is not done and it
should not be installed if you have sway-notification-center.

I disabled `sddm` and use `niri-session` to launch Niri. Currently
`gnome-keyring-daemon` handles my secrets. I mostly disabled `kwalletd`
(causing a pop up to unlock the keyring in KDE).

#### Systemd
You can either launch services with `spawn-at-startup` in the Niri config, or
use systemd. Systemd has better recovery on crashes and some other benefits.
Setup is easy if .service is already provided but also easy to write yourself,
see [example setup](https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup).
The symlinks should be restored with Stow (otherwise add them with
`systemctl --user add-wants niri.service <service file>`).

Currently `swayidle`, `swaybg`, `wlsunset`, `waybar`, `mpd-mpris` and
`xwayland-satellite` are launched with systemd.
You can manage them with `systemctl --user <command> <name>`.

This should also work if Niri is launched with `niri-session` from the tty.

#### Paths
Some files specify image paths, adjust them to images of your liking.
Files: `niri/config.kdl`, `swaylock/config` (also grep for ~/Pictures).

#### X11
Niri does not include X11, the recommended way to run xwayland is using
`xwayland-satellite`. The config launches: `xwayland-satellite" ":3`, and
sets `DISPLAY=:3` (to make it more predictable).

Launching applications with this explicitly requires changing the .desktop file
(when using fuzzel):
```
Exec=env DISPLAY=:12 /some/binary`
```
Default locations: `/usr/share/applications/` and `~/.local/share/applications/`

I am considering adding (to my Niri setup):
- `swww`

> [!NOTE]
> manual build of `swww`, it requires `lz4-devel` (and `wayland-protocols-devel`,
> not verified by me). Also see build
> [intructions](https://github.com/LGFae/swww?tab=readme-ov-file#build)
> for swww. (some early experiments give bad overhead results, need more
> testing)

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

To customize the built-in keyboard, with a symbol layer and home row mods, I use
[KMonad](https://github.com/kmonad/kmonad). The systemd module and config file
to run it on startup is setup is setup. However the config is specific to my
laptop model and the de-CH locale I use.
Install it with `stack build && stack install`, after cloning the repo and
installing [stack](https://docs.haskellstack.org/en/stable/). If you are not
using my shell configs you usually need to add the stack install location to the
path.

# Dependencies
Main programs I use (included in Base):
- [fish](https://fishshell.com/)
- [tmux](https://github.com/tmux/tmux/wiki)
- [lf](https://github.com/gokcehan/lf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf) (dependency of several core programs)
- [zsh](https://sourceforge.net/p/zsh/code) (fallback POSIX shell)

Programs that have a full stow directory:
- [foot](https://codeberg.org/dnkl/foot) (separate due to various versions I use)
- [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- [rmpc](https://mierak.github.io/rmpc/) and [mpd](https://www.musicpd.org/)
(see [Music](#Music), optionally install [cava](https://github.com/karlstav/cava))
- [Alacritty](https://alacritty.org/) (my fallback cross-platform terminal)

Display Manager based desktop setups (see [Niri](#niri) and [Sway](#sway)):
- [niri](https://github.com/YaLTeR/niri)
- [sway](https://swaywm.org/)


# Other Programs
Some other programs that I usually install (no particular order)  
[euporie](https://github.com/joouha/euporie)  - TUI interface for jupyter notebooks  
[caligula](https://github.com/ifd3f/caligula) - single command wrapper for dd  
[wiremix](https://github.com/tsowell/wiremix)  - TUI frontend for pipewire  
[zk](https://github.com/zk-org/zk)       - Manage Zettelkasten style notes  
[impala](https://github.com/pythops/impala)   - TUI WiFi manager (iwd frontend)  
[lazygit](https://github.com/jesseduffield/lazygit)  - TUI for git  
[posting](https://github.com/darrenburns/posting)  - TUI for HTML requests  
[chafa](https://github.com/hpjansson/chafa)    - Convert images into terminal formats  
[isw](https://gitlab.com/thom-cameron/isw)      - Terminal stop watch (pomodoro)  

