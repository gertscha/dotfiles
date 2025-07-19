#--------------------------------------------------------------#
#           Aliases                                            #
#--------------------------------------------------------------#

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes.
# For a full list of active aliases, run `alias`.
alias ls='ls -a --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias cl='clear'
alias vi='nvim'

alias ..='cd ..'

alias zshec="$EDITOR $ZDOTDIR/.zshrc" # edit .zshrc
alias zshsc="source $ZDOTDIR/.zshrc"  # reload zsh configuration

alias coi='eval "$(~/.conda/conda shell.zsh hook)" && conda deactivate'
alias coa='conda activate'
alias cod='conda deactivate'


