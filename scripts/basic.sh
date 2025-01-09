#!/bin/sh

# install the basics, nerdfonts are a separate script
sudo apt update
sudo apt install nala
sudo nala install git build-essential ninja-build curl cmake zsh tmux
sudo nala install wl-clipboard ripgrep curl unzip gettext stow

# oh-my-zsh install, .zshrc is setup accordingly
cd ~
mkdir -p build
cd build
mkdir -p oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git oh-my-zsh

#tmux
cd ~
mkdir -p build/tmux/plugins
cd build/tmux
git clone https://github.com/tmux-plugins/tpm

# load configuration
cd ~/dotfiles
stow basic
cd ~

