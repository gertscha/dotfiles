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

    if command -v fd >/dev/null 2>&1; then
        FD_CMD="fd"
    elif command -v fdfind >/dev/null 2>&1; then
        FD_CMD="fdfind"
    else
        echo "Error: Neither 'fd' nor 'fdfind' could be found." >&2
        read -n 1 -s -p "Press any key to exit..."
        exit 1
    fi

    $FD_CMD -t f -e pdf . "${SEARCH_DIRS[@]}" > "$CACHE_FILE"
fi

file=$(fzf --delimiter / --with-nth -4.. --tiebreak=index < "$CACHE_FILE")

if [ -n "$file" ]; then
    zathura --fork "$file"
else
    echo "Opening a file is canceled."
fi
