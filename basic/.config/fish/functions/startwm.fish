function startwm
    if test -f "$XDG_CONFIG_HOME/wm-source.sh"
        bash "$XDG_CONFIG_HOME/wm-source.sh"
    else
        echo "wm-source.sh does not exist"
    end
end
