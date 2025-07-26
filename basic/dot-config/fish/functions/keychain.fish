function keychain
    # make sure we follow the custom path
    command keychain --absolute --dir $XDG_DATA_HOME/keychain $argv
end
