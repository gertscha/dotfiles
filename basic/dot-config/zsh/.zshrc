# ZSH shell config

# history config
HISTSTAMPS="dd.mm.yyyy"
HISTSIZE=10000
SAVEHIST=5000
HISTFILE=$HOME/.zsh_history

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# prompt config
# add OSC-133;A escape sequence before each prompt
precmd_prompt_marker() {
    print -Pn "\e]133;A\e\\"
}
# add conda info (if set)
precmd_conda_info() {
    CONDA_ENV=""
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        CONDA_ENV="($CONDA_DEFAULT_ENV) "
    fi
}
autoload -Uz vcs_info
precmd_functions+=( precmd_prompt_marker )
precmd_functions+=( vcs_info )
precmd_functions+=( precmd_conda_info )
zstyle ':vcs_info:git:*' formats '[%F{blue}%b%f]'
setopt PROMPT_SUBST
PROMPT='${CONDA_ENV}${vcs_info_msg_0_}[%F{green}%32<...<%~%<<%f]%F{yellow} ➤%f '

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
# keychain is used to manage the agent, but keys are handled with KeePassXC
if command -v keychain &> /dev/null; then
    eval `keychain -q --absolute --dir "$XDG_DATA_HOME/keychain" --eval`
    # source "$XDG_DATA_HOME/keychain/${HOSTNAME}-sh"

    # make sure we follow the custom path
    alias keychain="keychain --absolute --dir \"$XDG_DATA_HOME/keychain\""
fi
