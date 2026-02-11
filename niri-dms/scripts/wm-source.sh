#!/usr/bin/env bash

# XDG autostart does not capture the theme settings, a manual start is my
# current work around

# thunderbird & # is okay, since it has its own theme

# nextcloud --background & # is okay, since does not need the theme

# if the ssh-agent does not work see how this is done in my sway setup
keepassxc &> /dev/null &
