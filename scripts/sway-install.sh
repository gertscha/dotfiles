#!/bin/sh
cd ~

# install sway, assumes there is a gnome DE installed
sudo apt update
sudo apt install nala
sudo nala install sway waybar swayidle swaylock foot
sudo nala install brightnessctl swayimg wlogout
sudo nala install mako-notifier wayland-protocols xwayland
sudo nala install wofi grim slurp grimshot

cd ~/dotfiles
stow sway
cd ~
