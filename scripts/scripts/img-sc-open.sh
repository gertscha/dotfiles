#!/bin/bash

# === Configuration ===
SEARCH_DIRS=(
    "$HOME/Pictures/Screenshots/"
)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/scripts_cache"
CACHE_FILE="$CACHE_DIR/fzf_img_sc_cache"

mkdir -p "$CACHE_DIR"

if command -v fd >/dev/null 2>&1; then
    FD_CMD="fd"
elif command -v fdfind >/dev/null 2>&1; then
    FD_CMD="fdfind"
else
    echo "Error: Neither 'fd' nor 'fdfind' could be found." >&2
    read -n 1 -s -p "Press any key to exit..."
    exit 1
fi

$FD_CMD -t f -e jpg -e jpeg -e png -e jxl . "${SEARCH_DIRS[@]}" > "$CACHE_FILE"
file=$(fzf --delimiter / --with-nth -4.. --tiebreak=index --tac < "$CACHE_FILE")

if [ -n "$file" ]; then
    setsid -f swayimg "$file"
else
    echo "Opening a file is canceled."
fi
