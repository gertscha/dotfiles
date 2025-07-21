# .bash_profile

if [ "$(tty)" = "/dev/tty1" ] ; then
    export QT_QPA_PLATFORM=wayland-egl
    export QT_QPA_PLATFORMTHEME=qt6ct
    export ELECTRON_OZONE_PLATFORM_HINT=auto
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=Niri
    export DISPLAY=":3"
    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export INPUT_METHOD=ibus
fi

if command -v nvim &> /dev/null; then
    export EDITOR=nvim
fi

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"


# history files
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# other paths (see ArchWiki for which variables are needed for which folder)
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm"

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

