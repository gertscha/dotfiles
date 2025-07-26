function init-conda
    eval ~/.conda/conda "shell.fish" "hook" $argv | source
    command conda deactivate
end
