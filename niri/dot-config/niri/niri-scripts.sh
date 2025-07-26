#!/usr/bin/env bash

# runs in subshell
close_all_windows() (
    set -euo pipefail
    local had_windows=1
    local iteration_count=0
    local max_iterations=32

    while [ "$had_windows" -eq 1 ]; do
        had_windows=0
        # get state
        local windows_json=$(niri msg --json windows)
        local workspaces_json=$(niri msg --json workspaces)

        # safety abort in case something goes wrong
        iteration_count=$((iteration_count + 1))
        if [ "$iteration_count" -gt "$max_iterations" ]; then
            notify-send -u "critical" \
                "'Close all' script aborted after ${max_iterations} iterations"
            break
        fi

        # filter workspaces that have at least one window
        local workspaces_info=$(jq -c \
            'sort_by(.idx) | reverse | .[] | select(.active_window_id != null)' \
            <<<"$workspaces_json")

        local workspace_count=$(grep -c . <<<"$workspaces_info")
        if [ "$workspace_count" -gt 0 ]; then
            had_windows=1
            local first_workspace_with_windows=$(head -n1 <<<"$workspaces_info")
            local w_id=$(jq -r '.id' <<<"$first_workspace_with_windows")
            local w_idx=$(jq -r '.idx' <<<"$first_workspace_with_windows")
            local output=$(jq -r '.output' <<<"$first_workspace_with_windows")
            # Count windows in this workspace
            local window_cnt=$(echo $windows_json | jq --arg wid "$w_id" \
                '[.[] | select(.workspace_id == ($wid | tonumber))] | length')

            niri msg action focus-monitor "$output"
            sleep 0.02
            niri msg action focus-workspace "$w_idx"
            for ((j=0; j<window_cnt; j++)); do
                niri msg action close-window
                sleep 0.02
            done
            sleep 0.06
        fi
    done
    sleep 0.2
)

# niri msg action toggle-overview
close_all_windows # defined above
# niri msg action toggle-overview
niri msg action focus-monitor DP-1
sleep 0.1
niri msg action focus-workspace code

