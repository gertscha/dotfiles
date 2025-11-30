#!/bin/bash

# === Configuration ===
SEARCH_DIRS=(
    "$HOME/Pictures/Screenshots/"
)
CACHE_DIR="${SCRIPT_CACHE_DIR:-$HOME/.local/share}"
CACHE_FILE="$CACHE_DIR/fzf_img_sc_cache"

mkdir -p "$CACHE_DIR"

# Regenerate cache if 'refresh' argument passed, file missing, or older than 24h
if [ "$1" == "refresh" ] || [ ! -f "$CACHE_FILE" ] || [ -n "$(find "$CACHE_FILE" -mtime +0 2>/dev/null)" ]; then
    echo "Refreshing image cache..." >&2
    fd -t f -e jpg -e jpeg -e png -e jxl . "${SEARCH_DIRS[@]}" > "$CACHE_FILE"
fi

# file=$(cat "$CACHE_FILE" | fzf)
file=$(cat "$CACHE_FILE" | fzf --delimiter / --with-nth -4.. --tiebreak=index --tac)

if [ -n "$file" ]; then
    setsid -f swayimg "$file"
else
    echo "Opening a file is canceled."
fi
