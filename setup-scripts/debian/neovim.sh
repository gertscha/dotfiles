#!/bin/sh
# setup neovim

# build it
cd ~
mkdir -p build
cd build
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# load configuration
cd ~/dotfiles
stow neovim
cd ~
