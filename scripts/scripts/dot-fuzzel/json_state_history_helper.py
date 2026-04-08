#!/usr/bin/env python3
"""
Helper script to update the recent selections history in a JSON state file.
Takes the filename and the new selection string as input.
"""

import sys
import json
import os
from pathlib import Path


def main():
    if len(sys.argv) < 3:
        print("Usage: json_state_history_helper.py <filename> <new_selection>",
              file=sys.stderr)
        sys.exit(1)

    filename = sys.argv[1]
    new_sel = sys.argv[2]

    xdg_data = os.environ.get('XDG_DATA_HOME')
    data_dir = Path(xdg_data) if xdg_data else Path.home() / ".local" / "share"
    filepath = data_dir / "scripts_cache" / filename

    try:
        with open(filepath, 'r') as f:
            data = json.load(f)
    except Exception:
        data = {}

    recent = data.get('recent_selections', '').split(';')
    # filter out empty entries
    recent = [r for r in recent if r]

    if new_sel in recent:
        recent.remove(new_sel)
    recent.insert(0, new_sel)

    # Keep only the latest 3
    data['recent_selections'] = ';'.join(recent[:3])

    with open(filepath, 'w') as f:
        json.dump(data, f, indent=4)


if __name__ == "__main__":
    main()
