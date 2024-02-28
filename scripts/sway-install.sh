#!/bin/sh
cd ~

# install sway, assumes there is a gnome DE installed
apt update
apt install nala
nala install sway waybar swayidle swaylock foot
nala install brightnessctl swayimg wlogout
nala install mako-notifier wayland-protocols xwayland
nala install wofi grim slurp grimshot swayimg

cd ~/dotfiles
stow sway
cd ~
