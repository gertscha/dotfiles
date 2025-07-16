function init-conda
    eval "$(~/.conda/conda shell.fish hook)"
    conda deactivate
end
