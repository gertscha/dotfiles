#!/bin/sh
# setup neovim

# build it
mkdir -p $HOME/sys_build
cd $HOME/sys_build
git clone https://github.com/neovim/neovim neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# load configuration
cd $HOME/dotfiles
stow neovim
cd ~
