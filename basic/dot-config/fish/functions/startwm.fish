function startwm
    if test -f "$HOME/wm-source.sh"
        bash "$HOME/wm-source.sh"
    else
        echo "wm-source.sh does not exist"
    end
end
