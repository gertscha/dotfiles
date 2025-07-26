#!/bin/bash

# Source the keychain environment file
source "$XDG_DATA_HOME/keychain/$(hostname)-sh"

# Launch KeePassXC
exec keepassxc
