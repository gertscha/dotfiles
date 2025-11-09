#!/bin/bash
set -euo pipefail

USER_HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)
KDBX_PATH="$USER_HOME/ln/files/Nextcloud/KeePassDB.kdbx"

# The key file attachment in the KeePassXC database
KEY_ENTRY_NAME="Backup LUKS"
KEY_ATTACHMENT_NAME="ToshibaBackupKey"

# The UUID of the disk (find with: sudo blkid)
DISK_UUID="7a28ba26-eb27-4bb2-8014-bca982519e57"

MAPPER_NAME="ToshibaBackup"
MOUNT_POINT="/mnt/backup"


if [[ $EUID -ne 0 ]]; then
   echo "This script needs root privileges. Re-running with sudo..."
   # Re-execute this script with sudo
   exec sudo "$0" "$@"
fi

for cmd in keepassxc-cli cryptsetup findfs mktemp shred mount; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not installed" >&2
        exit 1
    fi
done

mkdir -p "$MOUNT_POINT"

DEVICE_PATH=$(findfs "UUID=$DISK_UUID")
if [[ -z "$DEVICE_PATH" ]]; then
    echo "Error: Could not find a disk with UUID $DISK_UUID" >&2
    exit 1
fi

KEY_FILE=$(mktemp /dev/shm/backup.XXXXXXXX)
if [[ ! -f "$KEY_FILE" ]]; then
    echo "Error: Could not create temporary key file" >&2
    exit 1
fi

chmod 600 "$KEY_FILE"
trap 'shred -f -u -z "$KEY_FILE";' EXIT

echo "Enter KeePassXC DB password:"
if ! keepassxc-cli attachment-export -q "$KDBX_PATH" "$KEY_ENTRY_NAME" "$KEY_ATTACHMENT_NAME" "$KEY_FILE"; then
    echo "Failed to export key file"
    exit 1 # Trap will run
fi

echo "Unlocking LUKS volume..."
if ! cryptsetup luksOpen --key-file="$KEY_FILE" "$DEVICE_PATH" "$MAPPER_NAME"; then
    echo "Error: Failed to unlock LUKS volume" >&2
    exit 1 # Trap will run
fi

if ! mount "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT"; then
    echo "Error: Failed to mount the unlocked volume" >&2
    cryptsetup luksClose "$MAPPER_NAME"
    exit 1 # Trap will run
fi

echo "Success! Disk mounted at $MOUNT_POINT"

