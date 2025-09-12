function zkcd
    set dir (grep '^dir =' $XDG_CONFIG_HOME/zk/config.toml | cut -d= -f2- | tr -d ' "')
    command cd (eval $dir)
end
