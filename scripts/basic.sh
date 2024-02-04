#!/bin/sh

# install the basics, nerdfonts are a separate script
apt update
apt install nala
nala install git build-essential ninja-build curl cmake zsh tmux
nala install wl-clipboard ripgrep curl unzip gettext

# some languages
nala install golang
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# oh-my-zsh install, .zshrc is setup accordingly
cd ~
mkdir -p build
cd build
git clone https://github.com/ohmyzsh/ohmyzsh.git
mv ohmyzsh oh-my-zsh

# neovim
cd ~
mkdir -p build
cd build
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

#tmux
cd ~
mkdir -p build/tmux/plugins
cd build/tmux
git clone https://github.com/tmux-plugins/tpm

#load configuration
cd ~/dotfiles
stow base
cd ~

# firewall, don't know if this is really needed
sudo nala install ufw
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
