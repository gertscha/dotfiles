function pomodoro
    isw \
    --intervals 1500,300 \
    --colours 2,1 \
    --shell 'notify-send isw "Pomodoro interval (%c) complete"' \
    --pause \
    --descending \
    --show-cycle
end
