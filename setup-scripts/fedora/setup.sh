#!/bin/sh

sudo dnf update
# base
sudo dnf -y install vim alacritty stow fish zsh vlc git git-gui fd tmux tree bat zip
# dev
sudo dnf -y install @c-development @development-tools
sudo dnf -y install xxd gcc lvm python3-pip
sudo dnf -y install javac gdb jq zig npm clang boost
sudo dnf intall ffmpeg --allowerasing
# neovim
sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra
sudo dnf -y install fzf lua-5.1 luarocks tree-sitter
# steam
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install steam -y

# other apps
sudo dnf -y install thunderbird texlive-scheme-basic
sudo dnf -y install texlive-standalone texlive-bibtex texlive-enumitem
sudo dnf -y install texlive-fancyhdr texlive-hyphen texlive-pgf texlive-beamer
sudo dnf -y install texlive-babel texlive-amsmath texlive-acro

# virt
sudo dnf -y install wine virt-manager foot blivet-gui

# kde
sudo dnf -y install ksshaskpass evince

# niri
sudo dnf -y install niri waybar swaylock swaybg swayidle wpctl mako wl-clipboard
