#!/usr/bin/env bash

# XDG autostart does not capture the theme settings, a manual start is my
# current work around

thunderbird &

# eval `keychain -q --eval --absolute --dir "$XDG_DATA_HOME/keychain"`
systemctl --user start keepassxc
