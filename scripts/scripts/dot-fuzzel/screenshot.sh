#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

FILENAME="screenshot.json"

# Define our constants and initial values
DEFAULTS=(
    "file_path=Pictures/Screenshots"
    "file_name=tmp"
    "default_base_path=$HOME"
    "markdown_base_path=$HOME"
    "markdown_int_dir=Documents"
    "markdown_mode=False"
)
DMENU_CMD="fuzzel --dmenu --width=80"

# Helper function to extract a value from the Python output
get_val() {
    echo "$STATE_OUTPUT" | grep "^$1: " | sed "s/^$1: //"
}

# --- Main Menu Loop ---
while true; do
    # Fetch/Init state from the first python script
    STATE_OUTPUT=$(python3 "$SCRIPT_DIR/json_state_loader_helper.py" "$FILENAME" "${DEFAULTS[@]}")

    # Display the menu
    SELECTION=$(printf "[Screenshot]\n[Edit]\n%s" "$STATE_OUTPUT" \
        | $DMENU_CMD --mesg="Screenshot Menu")

    case "$SELECTION" in
        "[Edit]")
            python3 "$SCRIPT_DIR/json_state_editor_helper.py" "$FILENAME"
            ;;
        "[Screenshot]")
            break
            ;;
        "")
            # User pressed Esc
            exit 0
            ;;
        *)
            # Ignored if user clicks a purely informational state key-value pair
            continue
            ;;
    esac
done

# --- Extract State Variables ---
SAVE_PATH_DIR=$(get_val "file_path")
SAVE_NAME_BASE=$(get_val "file_name")
BASE_PATH=$(get_val "default_base_path")
MD_BASE=$(get_val "markdown_base_path")
MD_DIR=$(get_val "markdown_int_dir")
MD_MODE=$(get_val "markdown_mode")

# Prompt for suffix
SUFFIX=$(printf "\n" | $DMENU_CMD --mesg="Add suffix (optional):")
FINAL_NAME="${SAVE_NAME_BASE}${SUFFIX}.png"

# Determine final path based on Markdown mode
if [[ "$MD_MODE" == "True" ]]; then
    FULL_SAVE_PATH="${MD_BASE}/${MD_DIR}/${FINAL_NAME}"
else
    FULL_SAVE_PATH="${BASE_PATH}/${SAVE_PATH_DIR}/${FINAL_NAME}"
fi

# Ensure parent directories exist
mkdir -p "$(dirname "$FULL_SAVE_PATH")"

echo $FULL_SAVE_PATH

# --- Overwrite Check ---
if [[ -f "$FULL_SAVE_PATH" ]]; then
    OVERWRITE=$(printf "[Overwrite]\n[Cancel]" \
        | $DMENU_CMD --mesg="Warning: '${FINAL_NAME}' exists!")
    if [[ "$OVERWRITE" != "[Overwrite]" ]]; then
        wl-copy "Aborted screenshot copy"
        exit 0
    fi
fi

# --- Take Screenshot ---
GEOMETRY=$(slurp 2> /dev/null)
if [[ -z "$GEOMETRY" ]]; then
    exit 0 # Exit cleanly if aborted
fi
grim -g "$GEOMETRY" -t png "$FULL_SAVE_PATH"

# --- Copy to clipboard ---
if [[ $? -eq 0 ]]; then
    if [[ "$MD_MODE" == "True" ]]; then
        WIDTH=$(echo "$GEOMETRY" | awk '{print $2}' | cut -d'x' -f1)
        HALF_WIDTH=$((WIDTH / 2))
        echo -n "![[${FINAL_NAME} | ${HALF_WIDTH}]]" | wl-copy
    else
        wl-copy -t image/png < "$FULL_SAVE_PATH"
    fi
else
    printf "Failed" | $DMENU_CMD --mesg="Error: Failed to take screenshot"
fi
