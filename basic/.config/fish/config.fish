if status is-interactive
    set -gx EDITOR nvim
end

set -gx LS_COLORS "di=32:ln=36:so=1;37:pi=1;37:ex=1;31:bd=37:cd=37:su=30;47:sg=30;47:tw=1;32:ow=1;32"
set -gx LSCOLORS "cxgxHxHxBxhxhxahahCxCx"
set -gx GREP_COLORS "sl=49;39:cx=49;39:mt=49;31;1:fn=49;32:ln=49;33:bn=49;33:se=1;36"

set -gx MANPATH "$MANPATH:~/build_sys/install/man"

fish_add_path ~/go/bin
fish_add_path ~/build_sys/install/bin
