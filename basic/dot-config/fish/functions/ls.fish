function ls
    if command -sq eza
        eza --hyperlink $argv
    else
        command ls --hyperlink $argv
    end
end
