#!/bin/zsh

# install some nerdfonts
cd ~
sudo apt install -y unzip wget
mkdir -p .fonts
cd .fonts

fontsls=(
"MartianMono"
# "Hack"
"FiraMono"
# "Noto"
)

for font in ${fontsls[@]}
  do
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/$font.zip
    unzip $font.zip -d ~/.fonts/$font/
    rm $font.zip
  done
fc-cache -v

