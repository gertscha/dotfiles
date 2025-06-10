# ZSH shell config

# history config
HISTSTAMPS="dd.mm.yyyy"
HISTSIZE=10000
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# prompt config
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '[%F{blue}%b%f]'
setopt PROMPT_SUBST
PROMPT='${vcs_info_msg_0_}[%F{green}%32<...<%~%<<%f]%F{yellow} ➤%f '

# User configuration
export ZRCDIR=$ZDOTDIR/rc

#--------------------------------------------------------------#
#           Options (path changes in here)                     #
#--------------------------------------------------------------#
source "$ZRCDIR/options.zsh"


#--------------------------------------------------------------#
#           Aliases                                            #
#--------------------------------------------------------------#
source "$ZRCDIR/alias.zsh"


#--------------------------------------------------------------#
#           SSH Key Setup                                      #
#--------------------------------------------------------------#
source "$ZRCDIR/ssh.zsh"

