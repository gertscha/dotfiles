#!/bin/bash

MAPPER_NAME="ToshibaBackup"
MOUNT_POINT="/mnt/backup"

if [[ $EUID -ne 0 ]]; then
   echo "This script needs root privileges. Re-running with sudo..."
   # Re-execute this script with sudo
   exec sudo "$0" "$@"
fi

for cmd in cryptsetup mount; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

umount "$MOUNT_POINT"
cryptsetup close "$MAPPER_NAME"
