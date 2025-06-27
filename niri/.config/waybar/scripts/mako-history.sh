#!/usr/bin/env bash

# Script to display and interact with Mako notification history using fzf

# Get the notification list from mako
NOTIFICATION_LIST=$(makoctl list)

# Use fuzzel to select a notification
echo "$NOTIFICATION_LIST" | fuzzel --dmenu

