#!/bin/bash

# The UUID of the LUKS partition (find with: sudo blkid)
DISK_UUID="47a29562-17a9-4b89-9d38-5ac996946160"

MAPPER_NAME="samsung_bar1"
MOUNT_POINT="/mnt/stick"

ORIGINAL_USER=${SUDO_USER:-$USER}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script needs root privileges. Re-running with sudo..."
   # Re-execute this script with sudo
   exec sudo "$0" "$@"
fi

for cmd in cryptsetup findfs mountpoint; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not installed" >&2
        exit 1
    fi
done

mkdir -p "$MOUNT_POINT"

# ==========================================
# UNMOUNT/LOCK (if already mounted)
# ==========================================
if mountpoint -q "$MOUNT_POINT"; then
    echo "Trying to unmount stick"

    if ! umount "$MOUNT_POINT"; then
        echo "Error: Failed to unmount $MOUNT_POINT." >&2
        exit 1
    fi

    if ! cryptsetup luksClose "$MAPPER_NAME"; then
        echo "Error: Failed to lock LUKS volume '$MAPPER_NAME'." >&2
        exit 1
    fi

    echo "Disk safely unmounted and locked."
    exit 0
fi

# ==========================================
# UNLOCK/MOUNT (if not mounted)
# ==========================================

# Find the device path using the UUID
DEVICE_PATH=$(findfs "UUID=$DISK_UUID")
if [[ -z "$DEVICE_PATH" ]]; then
    echo "Error: Could not find a LUKS partition with UUID $DISK_UUID" >&2
    exit 1
fi

echo "Unlocking LUKS volume..."
# cryptsetup will natively prompt you for the password right here
if ! cryptsetup luksOpen "$DEVICE_PATH" "$MAPPER_NAME"; then
    echo "Error: Failed to unlock LUKS volume. Incorrect password?" >&2
    exit 1
fi

echo "Mounting..."
if ! mount "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT"; then
    echo "Error: Failed to mount the unlocked volume" >&2
    # Cleanup by closing the LUKS volume if mounting fails
    cryptsetup luksClose "$MAPPER_NAME"
    exit 1
fi

# Give ownership back to your regular user so you can write files to it
chown -R "$ORIGINAL_USER:$ORIGINAL_USER" "$MOUNT_POINT"

echo "samsung_bar1 mounted at $MOUNT_POINT"
