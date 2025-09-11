function zkcd
    set dir (grep '^dir =' ~/.config/zk/config.toml | cut -d= -f2- | tr -d ' "')
    eval $dir
end
