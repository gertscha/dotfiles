#!/usr/bin/env bash

# Source the keychain environment file
source "$XDG_DATA_HOME/keychain/$(hostname)-sh"

# Launch KeePassXC
keepassxc
