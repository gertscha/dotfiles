#!/usr/bin/env python3
"""
Helper script to edit a JSON file interactively with a dmenu (fuzzel)
Takes the filename as input, looks in: ~/.local/share/scripts_cache/
"""

import sys
import json
import os
import subprocess
from pathlib import Path


def show_menu(options: list[str], prompt: str = "") -> str | None:
    cmd = ["fuzzel", "--dmenu", "--width=80"]
    if not options or options == [""]:
        cmd.append("--lines=0")
    if prompt:
        cmd.append(f"--mesg={prompt}")

    try:
        res = subprocess.run(cmd,
                             input="\n".join(options),
                             capture_output=True,
                             text=True,
                             check=False)
        return res.stdout.strip() if res.returncode == 0 else None
    except Exception:
        return None


def main():
    if len(sys.argv) < 2:
        print("Error: Specify a state file!")
        sys.exit(1)

    filename = sys.argv[1]
    xdg_data = os.environ.get('XDG_DATA_HOME')
    filepath = (Path(xdg_data) if xdg_data else Path.home() / ".local" /
                "share") / "scripts_cache" / filename

    try:
        with open(filepath, 'r') as f:
            data = json.load(f)
    except Exception:
        data = {}

    # Edit loop
    while True:
        items = [f"{k}: {v}" for k, v in sorted(data.items())]
        selection = show_menu(["[Add New Entry]"] + items + ["[Exit]"],
                              prompt="Edit State")

        if not selection or selection == "[Exit]":
            break

        if selection == "[Add New Entry]":
            k = show_menu([""], prompt="Enter new key:")
            if k:
                v = show_menu([""], prompt=f"Enter value for {k}:")
                if v is not None:
                    if v.lower() == 'true': v = True
                    elif v.lower() == 'false': v = False
                    data[k] = v
        else:
            key = selection.split(":", 1)[0].strip()
            if key in data:
                action = show_menu(
                    ["[Edit Value]", "[Delete Entry]", "[Cancel]"],
                    prompt=f"'{key}: {data[key]}'")
                if action == "[Edit Value]":
                    new_val = show_menu(
                        [""],
                        prompt=
                        f"Current value: {data[key]}\nEnter new value for {key}:"
                    )
                    if new_val is not None:
                        if new_val.lower() == 'true': new_val = True
                        elif new_val.lower() == 'false': new_val = False
                        data[key] = new_val
                elif action == "[Delete Entry]":
                    del data[key]

    with open(filepath, 'w') as f:
        json.dump(data, f, indent=4)


if __name__ == "__main__":
    main()
