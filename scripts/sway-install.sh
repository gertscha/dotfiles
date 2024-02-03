#!/bin/sh
cd ~

# install sway, assumes there is a gnome DE installed
apt update
apt install nala
nala install stow brightnessctl swayimg wlogout
nala install wayland-protocols xwayland
nala install sway waybar swayidle swaylock foot
nala mako-notifier grim slurp grimshot wofi

cd ~/dotfiles
stow sway
cd ~
