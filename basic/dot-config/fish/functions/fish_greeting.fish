function fish_greeting
    string join '' --  (set_color brblack) 'Launched ' (fish --version | cut -d'-' -f1) ', ' (command date +"%d/%m/%y, %H:%M:%S")
end
