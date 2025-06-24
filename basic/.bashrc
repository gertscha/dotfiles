# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# path

PATH=$PATH:~/go/bin
PATH=$PATH:~/build_sys/install/bin

export PATH


# man path

MANPATH=$MANPATH:~/build_sys/install/man

export MANPATH


# exports
export EDITOR=nvim
export SYSTEMD_EDITOR=vim


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# prompt

PROMPT_DIRTRIM=3
PROMPT_COMMAND='
  PS1_GIT_BRANCH=""
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    PS1_GIT_BRANCH="[\[\e[38;5;39m\]$(git branch --show-current 2>/dev/null)\[\033[0m\]]"
  fi
  PS1="${PS1_GIT_BRANCH}[\[\e[38;5;70m\]\w\[\033[0m\]] \$ "
'

# alias

alias vi='nvim'
alias gs='git status'
alias ..='cd ..'
