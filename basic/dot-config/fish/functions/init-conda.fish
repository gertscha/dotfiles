function init-conda
    eval ~/.conda/conda "shell.fish" "hook" $argv | source
    conda deactivate
end
