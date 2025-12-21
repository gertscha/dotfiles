#!/bin/bash

# ==============================================================================
# Borg Backup Script using KeePassXC-CLI
# ==============================================================================

USER_HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)
KEEPASS_DB="$USER_HOME/ln/files/Nextcloud/KeePassDB.kdbx"

# The name or path of the entry inside KeePassXC that holds the Borg passphrase
# Example: "Servers/MyBackup" or just "MyBackup" if it's in the root
KEEPASS_ENTRY="Backup Borg Desktop"

# Borg Repository Location (Local path or user@host:/path)
BORG_REPO="/mnt/backup/Desktop"

# Directories to backup
DOC_DIRS="/media/data0/Documents /media/data0/Pictures /media/data0/Music"
DATA_DIRS="/media/data0/Nextcloud $USER_HOME/dotfiles"

SOURCE_DIRS="$DOC_DIRS $DATA_DIRS"

# ------------------------------------------------------------------------------

if ! command -v borg &> /dev/null; then
    echo "Error: 'borg' is not installed."
    exit 1
fi

if ! command -v keepassxc-cli &> /dev/null; then
    echo "Error: 'keepassxc-cli' is not installed."
    exit 1
fi

if [ ! -f "$KEEPASS_DB" ]; then
    echo "Error: KeePassXC database not found at $KEEPASS_DB"
    exit 1
fi

if [ ! -d "$BORG_REPO" ]; then
    echo "Error: Borg Repo directory not found ($BORG_REPO)"
    exit 1
fi


echo "-----------------------------------------------------"
echo "Borg backup script (run with Mod+Shfit+S)"
echo "------------------------------------------------"

echo "Enter the keepassxc password to set BORG_PASSPHRASE"
export BORG_PASSPHRASE=$(keepassxc-cli show -q -s -a password "$KEEPASS_DB" "$KEEPASS_ENTRY")

if [ -z "$BORG_PASSPHRASE" ]; then
    echo "Error: Could not retrieve password."
    exit 1
fi

if [ "$1" == "prune-v" ]; then
    echo "-----------------------------------------------------"
    echo "Prune preview"
    echo "-----------------------------------------------------"
    borg prune --list -y 5 --keep-3monthly 6 -m 8 -w 14 -d 7 --dry-run $BORG_REPO
elif [ "$1" == "prune-d" ]; then
    echo "-----------------------------------------------------"
    echo "Pruning archives"
    echo "-----------------------------------------------------"
    borg prune --list -y 5 --keep-3monthly 6 -m 8 -w 14 -d 7 $BORG_REPO
else
    echo "-----------------------------------------------------"
    echo "Starting Backup Process: $(date)"
    echo "-----------------------------------------------------"

    echo "To prune run with prune-v (preview) or prune-d (delete) argument"
    echo "Starting Borg backup..."
    borg create --stats --progress --compression lz4 --exclude-caches "$BORG_REPO"::{user}-{now} $SOURCE_DIRS
    echo "Starting Borg compact..."
    borg compact -p "$BORG_REPO"

    echo "-----------------------------------------------------"
    echo "Backup finished successfully at $(date)"
    echo "-----------------------------------------------------"
fi

unset BORG_PASSPHRASE
echo ""
echo "Done..."
echo "-----------------------------------------------------"

