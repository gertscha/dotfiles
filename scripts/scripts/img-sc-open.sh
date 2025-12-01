#!/bin/bash

# === Configuration ===
SEARCH_DIRS=(
    "$HOME/Pictures/Screenshots/"
)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/scripts_cache"
CACHE_FILE="$CACHE_DIR/fzf_img_sc_cache"

mkdir -p "$CACHE_DIR"

fd -t f -e jpg -e jpeg -e png -e jxl . "${SEARCH_DIRS[@]}" > "$CACHE_FILE"
file=$(cat "$CACHE_FILE" | fzf --delimiter / --with-nth -4.. --tiebreak=index --tac)

if [ -n "$file" ]; then
    setsid -f swayimg "$file"
else
    echo "Opening a file is canceled."
fi
