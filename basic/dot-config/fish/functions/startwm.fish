function startwm
    if test -f "$HOME/scripts/wm-source.sh"
        bash "$HOME/scripts/wm-source.sh"
    else
        echo "wm-source.sh does not exist"
    end
end
