#!/usr/bin/env bash

eval `keychain -q --eval --absolute --dir "$XDG_DATA_HOME/keychain"`

swaymsg workspace 8
thunderbird &
systemctl --user start nextcloud
systemctl --user start keepassxc
swaymsg layout stacking
