#!/usr/bin/env python3
"""
Helper script to edit init a JSON file and display it with dmenu (fuzzel)
Takes the filename as input, looks in: ~/.local/share/scripts_cache/
All extra arguments are used as initialization key=value pairs if the key
does not exist
"""

import sys
import json
import os
from pathlib import Path


def main():
    if len(sys.argv) < 2:
        print("Usage: json_state_loader_helper.py <filename> [key=value ...]",
              file=sys.stderr)
        sys.exit(1)

    filename = sys.argv[1]
    defaults = sys.argv[2:]

    xdg_data = os.environ.get('XDG_DATA_HOME')
    data_dir = Path(xdg_data) if xdg_data else Path.home() / ".local" / "share"
    config_dir = data_dir / "scripts_cache"
    config_dir.mkdir(parents=True, exist_ok=True)

    filepath = config_dir / filename
    data = {}

    # Load existing state if it exists
    if filepath.exists():
        try:
            with open(filepath, 'r') as f:
                data = json.load(f)
        except json.JSONDecodeError:
            pass  # Start fresh if corrupted

    # Apply defaults for missing keys
    changed = False
    for kv in defaults:
        if '=' in kv:
            key, val = kv.split('=', 1)
            if key not in data:
                # Convert 'true'/'false' strings to JSON booleans
                if val.lower() == 'true': val = True
                elif val.lower() == 'false': val = False

                data[key] = val
                changed = True

    # Save if we created the file or added new defaults
    if changed or not filepath.exists():
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=4)

    # Output the current state for Fuzzel
    for k, v in sorted(data.items()):
        print(f"{k}: {v}")


if __name__ == "__main__":
    main()
