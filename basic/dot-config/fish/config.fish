status is-interactive; or exit

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx CONDA_CHANGEPS1 false # prompt setup is manual

set -gx MANPATH "$MANPATH:~/build_sys/install/man"

set -gx LS_COLORS "di=32:ln=36:so=1;37:pi=1;37:ex=1;31:bd=37:cd=37:su=30;47:sg=30;47:tw=1;32:ow=1;32"
set -gx LSCOLORS "cxgxHxHxBxhxhxahahCxCx"
set -gx GREP_COLORS "sl=49;39:cx=49;39:mt=49;31;1:fn=49;32:ln=49;33:bn=49;33:se=1;36"
set -gx ZK_NOTEBOOK_DIR (eval echo (grep '^dir =' $XDG_CONFIG_HOME/zk/config.toml | cut -d= -f2- | tr -d ' "'))

if command -sq nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER 'nvim +Man!'
end

# keychain is used to manage the agent, but keys are handled with KeePassXC
if type -q command keychain
    command keychain -q --absolute --dir "$XDG_DATA_HOME/keychain"
    # --eval uses the $SHELL variable, which depends on the login shell
    # so we need to manually select the file to source here
    source "$XDG_DATA_HOME/keychain/$(hostname)-fish"
end

fish_add_path ~/.local/bin
fish_add_path ~/.local/share/go/bin
fish_add_path ~/.local/share/cargo/bin
fish_add_path ~/build_sys/install/bin
fish_add_path ~/.local/share/stack/bin

if type -q zoxide
    set -x _ZO_RESOLVE_SYMLINKS '1'
    set -x _ZO_DATA_DIR "$XDG_DATA_HOME/zoxide"
    zoxide init --cmd cd fish | source
end

# BEGIN opam configuration
test -r "$XDG_DATA_HOME/opam/opam-init/init.fish" && source "$XDG_DATA_HOME/opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true
# END opam configuration

