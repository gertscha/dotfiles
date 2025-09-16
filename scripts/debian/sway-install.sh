#!/bin/sh
cd ~

# install sway, assumes there is a gnome DE installed
sudo apt update
sudo apt install -y sway waybar swayidle swaylock foot wofi grim slurp \
grimshot brightnessctl swayimg wlogout network-manager-applet \
mako-notifier wayland-protocols xwayland

cd ~/dotfiles
stow --dotfiles sway
cd ~
