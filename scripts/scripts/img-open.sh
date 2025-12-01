#!/bin/bash

# === Configuration ===
SEARCH_DIRS=(
    "$HOME/Documents/"
    "$HOME/Pictures/"
    "$HOME/Downloads/"
    "$HOME/ln/files/Nextcloud/"
)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/scripts_cache"
CACHE_FILE="$CACHE_DIR/fzf_img_cache"

mkdir -p "$CACHE_DIR"

# Regenerate cache if 'refresh' argument passed, file missing, or older than 24h
if [ "$1" == "refresh" ] || [ ! -f "$CACHE_FILE" ] || [ -n "$(find "$CACHE_FILE" -mtime +0 2>/dev/null)" ]; then
    echo "Refreshing image cache..." >&2
    fd -t f -e jpg -e jpeg -e png -e jxl . "${SEARCH_DIRS[@]}" > "$CACHE_FILE"
fi

# file=$(cat "$CACHE_FILE" | fzf)
file=$(cat "$CACHE_FILE" | fzf --delimiter / --with-nth -4.. --tiebreak=index)

if [ -n "$file" ]; then
    setsid -f swayimg "$file"
else
    echo "Opening a file is canceled."
fi
