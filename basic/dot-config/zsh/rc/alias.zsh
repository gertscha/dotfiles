#--------------------------------------------------------------#
#           Aliases                                            #
#--------------------------------------------------------------#

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes.
# For a full list of active aliases, run `alias`.
alias stow='stow --dotfiles'
alias ls='ls -A --hyperlink --color=auto'
alias ll='ls -lAh --hyperlink --color=auto'
alias grep='grep --color=auto'
alias cl='clear'
alias vi='nvim'

alias ..='cd ..'

alias zshec="$EDITOR $ZDOTDIR/.zshrc" # edit .zshrc
alias zshsc="source $ZDOTDIR/.zshrc"  # reload zsh configuration

if [ -f "$XDG_CONFIG_HOME/wm-source.sh" ]; then
    alias startwm='bash "$XDG_CONFIG_HOME/wm-source.sh"'
fi

alias coi='eval "$(~/.conda/conda shell.zsh hook)" && conda deactivate'
alias coa='conda activate'
alias cod='conda deactivate'

alias mm='rmpc'
alias zkcd="cd $HOME/$ZK_NOTEBOOK_DIR"
