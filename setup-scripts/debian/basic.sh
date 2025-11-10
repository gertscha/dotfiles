#!/bin/sh

# install the basics, nerdfonts are a separate script
sudo apt update
sudo apt install git git-gui build-essential ninja-build curl cmake
sudo apt install wl-clipboard ripgrep curl unzip gettext stow zsh tmux \
vim alacritty fish fd-find tree bat zip gimp audacity fzf zoxide zathura \
zathura-pdf-poppler grim slurp jq

# load configuration
cd ~/dotfiles
stow --dotfiles basic
cd ~

#tmux
mkdir -p $XDG_CONFIG_HOME/tmux/plugins
cd $XDG_CONFIG_HOME/tmux/plugins
git clone https://github.com/tmux-plugins/tpm tpm

