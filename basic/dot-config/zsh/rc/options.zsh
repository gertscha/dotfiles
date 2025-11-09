#--------------------------------------------------------------#
#           Options                                            #
#--------------------------------------------------------------#


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# set editor
export EDITOR=nvim
export SYSTEMD_EDITOR=nvim

export ZK_NOTEBOOK_DIR="$(eval echo $(grep "^dir =" ~/.config/zk/config.toml | cut -d= -f2- | tr -d ' \"'))"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# opam configuration
[[ ! -r "$OPAMROOT/opam-init/init.zsh" ]] || source "$OPAMROOT/opam-init/init.zsh" > /dev/null 2> /dev/null

# extend path
path+=("$HOME/.local/bin")
path+=("$HOME/.local/share/go/bin")
path+=("$HOME/.local/share/cargo/bin")
path+=("$HOME/build_sys/install/bin")
path+=("$HOME/.local/share/stack/bin")

# extend man path
export MANPATH=$MANPATH:~/build_sys/install/man

export PATH
