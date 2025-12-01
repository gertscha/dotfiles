#!/bin/bash

# === Configuration ===
SEARCH_DIRS=(
    "$HOME/Documents/"
    "$HOME/Downloads/"
    "$HOME/ln/files/Nextcloud/"
)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/scripts_cache"
CACHE_FILE="$CACHE_DIR/fzf_pdf_cache"

mkdir -p "$CACHE_DIR"

# Regenerate cache if 'refresh' argument passed, file missing, or older than 24h
if [ "$1" == "refresh" ] || [ ! -f "$CACHE_FILE" ] || [ -n "$(find "$CACHE_FILE" -mtime +0 2>/dev/null)" ]; then
    echo "Refreshing PDF cache..." >&2
    find "${SEARCH_DIRS[@]}" -type f -name "*.pdf" > "$CACHE_FILE"
fi

# file=$(cat "$CACHE_FILE" | fzf)
file=$(cat "$CACHE_FILE" | fzf --delimiter / --with-nth -4.. --tiebreak=index)

if [ -n "$file" ]; then
    zathura --fork "$file"
else
    echo "Opening a file is canceled."
fi
