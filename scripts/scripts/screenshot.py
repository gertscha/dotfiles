#!/usr/bin/env python3
"""
Screenshots utility based on a JSON state (wofi, grim, slurp, wl-copy)
take and save screenshots based on the key-value pairs in the state
Allows adding, editing, and deleting of key-value pairs
"""

import json
import subprocess
import sys
import os
from pathlib import Path

XDG_DATA_HOME = os.environ.get('XDG_DATA_HOME')
if not XDG_DATA_HOME:
    DATA_DIR = Path.home() / ".local" / "share"
else:
    DATA_DIR = Path(XDG_DATA_HOME)

SCREENSHOT_DIR = "Pictures/Screenshots"
CONFIG_DIR = DATA_DIR / "py-scripts"
DATA_FILE = CONFIG_DIR / "screenshot.json"


def load_data(filepath: Path) -> dict:
    """
    Loads the JSON data from the specified file.
    If the file is corrupt, it backs it up and starts fresh.
    """
    if not filepath.exists():
        try:
            # Create an empty file
            with open(filepath, 'w') as f:
                json.dump({}, f)
            return {}
        except Exception as e:
            print(f"Error creating data file: {e}", file=sys.stderr)
            sys.exit(1)

    try:
        with open(filepath, 'r') as f:
            return json.load(f)
    except json.JSONDecodeError:
        print(f"Warning: Decode JSON file at {filepath} failed. Backing up.",
              file=sys.stderr)
        backup_file = filepath.with_suffix(".json.bak")
        filepath.rename(backup_file)
        return {}
    except Exception as e:
        print(f"Error loading data: {e}", file=sys.stderr)
        return {}


def save_data(filepath: Path, data: dict):
    """Saves the provided dictionary to the JSON file."""
    try:
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=4)
    except Exception as e:
        # Try to show an error in wofi if saving fails
        print(f"Error saving data: {e}", file=sys.stderr)
        show_menu([f"FATAL: Could not save data to {filepath}",
                   str(e)], "Save Error")


def show_menu(options: list[str], prompt: str = "") -> str | None:
    """
    Displays a wofi menu with the given options and returns the selected item.
    Returns None if the user cancels (e.g., presses Esc).
    """
    wofi_cmd = ["wofi", "--dmenu", f"--prompt={prompt}"]
    input_str = "\n".join(options)

    try:
        result = subprocess.run(wofi_cmd,
                                input=input_str,
                                capture_output=True,
                                text=True,
                                check=False)

        if result.returncode == 0:
            return result.stdout.strip()
        else:
            return None
    except FileNotFoundError:
        print("Error: 'wofi' command not found. Please install wofi.",
              file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred with wofi: {e}", file=sys.stderr)
        sys.exit(1)


def handle_add_new(data: dict) -> dict:
    """Guides the user through adding a new key-value pair."""
    key = show_menu([""], prompt="Enter new key:")
    if not key:
        return data

    if key in data:
        action = show_menu(["[Overwrite]", "[Cancel]"],
                           prompt=f"Key '{key}' already exists")
        if action == "[Cancel]":
            return data

    value = show_menu([""], prompt=f"Enter value for {key}:")
    if value is None:
        return data

    data[key] = value
    return data


def handle_item_selection(key: str, data: dict) -> dict:
    """Handles logic for when an existing item is selected."""
    current_value = data.get(key, "")
    action_prompt = f"'{key}: {current_value}'"
    actions = ["[Edit Value]", "[Delete Entry]", "[Cancel]"]
    action = show_menu(actions, prompt=action_prompt)

    if action == "[Edit Value]":
        new_value = show_menu([""], prompt=f"Enter new value for {key}:")
        if new_value is not None:
            data[key] = new_value

    elif action == "[Delete Entry]":
        del data[key]

    return data


def screenshot(data: dict):
    """Take a screenshot and save/follow up actions based on the state."""
    savepath = "file_path"
    savename = "file_name"
    basepath = "default_base_path"
    md_path = "markdown_base_path"
    md_dir = "markdown_int_dir"
    md_mode = "markdown_mode"
    if savepath not in data:
        data[savepath] = str(SCREENSHOT_DIR)
    if basepath not in data:
        data[basepath] = str(Path.home())
    if savename not in data:
        data[savename] = "tmp"
    if md_mode not in data:
        data[md_mode] = False
    if md_dir not in data:
        data[md_dir] = "Documents"
    if md_path not in data:
        data[md_path] = str(Path.home())

    number = show_menu(["", "Enter name suffix (optional)"])
    if not number:
        number = ""

    save_name = f"{data[savename]}{number}.png"
    save_path = f"{data[basepath]}/{data[savepath]}/{save_name}"
    if data[md_mode]:
        save_path = f"{data[md_path]}/{data[md_dir]}/{save_name}"

    try:
        slurp_result = subprocess.run("slurp", capture_output=True)
        if slurp_result.returncode == 0:
            geometry = slurp_result.stdout.strip()

            sc_cmd = ["grim", "-g", geometry, "-t", "png", save_path]
            result = subprocess.run(sc_cmd, capture_output=True, check=True)

            if result.returncode != 0:
                show_menu(["Failed to screenshot"])
                return data

            if data[md_mode]:
                width = geometry.decode().split(" ", 1)[1].split("x", 1)[0]
                cpy_cmd = ["wl-copy", f"![[{save_name} | {int(width) // 2}]]"]
                result = subprocess.run(cpy_cmd, timeout=10)
            else:
                catdata = subprocess.run(['cat', save_path],
                                         check=True,
                                         capture_output=True)
                if catdata.returncode == 0:
                    subprocess.run(['wl-copy', "-t", "image/png"],
                                   input=catdata.stdout,
                                   timeout=10)
                else:
                    show_menu(["Failed to change clipboard"])
                    return data

    except Exception as e:
        print(f"An unexpected error occurred with grim: {e}", file=sys.stderr)
        sys.exit(1)

    return data


def main():
    DATA_FILE.parent.mkdir(parents=True, exist_ok=True)
    while True:
        data = load_data(DATA_FILE)

        json_data = [f"{k}: {v}" for k, v in data.items()]
        json_data.sort()

        special_options = ["[Screenshot]", "[Add New Entry]", "[Exit]"]

        selection = show_menu(special_options + json_data,
                              prompt="Persistent JSON Menu")

        if selection is None or selection == "[Exit]":
            break

        if selection == "[Add New Entry]":
            data = handle_add_new(data)
            save_data(DATA_FILE, data)

        elif selection == "[Screenshot]":
            data = screenshot(data)
            save_data(DATA_FILE, data)
            break

        elif selection == "":
            continue

        else:
            try:
                selected_key = selection.split(":", 1)[0].strip()
                if selected_key in data:
                    data = handle_item_selection(selected_key, data)
                    save_data(DATA_FILE, data)
                else:
                    # This shouldn't happen if parsing is correct
                    show_menu([f"Error: Could not find key '{selected_key}'"],
                              "Error")
            except Exception as e:
                show_menu([f"Error parsing selection: {e}"], "Error")


if __name__ == "__main__":
    main()
