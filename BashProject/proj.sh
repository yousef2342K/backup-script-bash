#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Enter: $0 <sourcedirectory> <backupdirectory> <interval-secs> <max-backups>"
    exit 1
fi

SOURCE_DIR=$1
BACKUP_DIR=$2
INTERVAL=$3
MAX_BACKUPS=$4

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory $SOURCE_DIR does not exist!"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory $BACKUP_DIR does not exist! I'll Create it..."
    mkdir -p "$BACKUP_DIR"
fi

get_timecreated() {
    date +"%Y-%m-%d-%H-%M-%S"
}

backup_dir() {
    TIMECREATED=$(get_timecreated)
    DEST_DIR="$BACKUP_DIR/$TIMECREATED"
    echo "Backing up $SOURCE_DIR to $DEST_DIR"
    cp -r "$SOURCE_DIR" "$DEST_DIR"
    ls -lR "$SOURCE_DIR" > "$DEST_DIR/directory-info.last"
}

check_for_changes_and_backup() {
    TIMECREATED=$(get_timecreated)
    DEST_DIR="$BACKUP_DIR/$TIMECREATED"
    

    LAST_BACKUP_DIR=$(ls -1t "$BACKUP_DIR" | head -n 1)



    mkdir -p "$DEST_DIR"
    ls -lR "$SOURCE_DIR" > "$DEST_DIR/directory-info.new"

    if [ -f "$BACKUP_DIR/$LAST_BACKUP_DIR/directory-info.last" ]; then
        if cmp -s "$BACKUP_DIR/$LAST_BACKUP_DIR/directory-info.last" "$DEST_DIR/directory-info.new"; then
            echo "No changes detected, skipping backup."
            rm -rf "$DEST_DIR"
        else
            echo "Changes detected, backing up..."
            cp -r "$SOURCE_DIR" "$DEST_DIR"
            echo "$BACKUP_DIR/$LAST_BACKUP_DIR TO $DEST_DIR" 
            mv "$DEST_DIR/directory-info.new" "$DEST_DIR/directory-info.last"
        fi
    else
        echo "No previous directory-info.last file found. You deleted the folders."
        cp -r "$SOURCE_DIR" "$DEST_DIR"
        mv "$DEST_DIR/directory-info.new" "$DEST_DIR/directory-info.last"
    fi
}

cleanup_old_backups() {
    BACKUPS_COUNT=$(ls -1 "$BACKUP_DIR" | wc -l)
    if [ "$BACKUPS_COUNT" -gt "$MAX_BACKUPS" ]; then
        OLD_BACKUPS=$(ls -1t "$BACKUP_DIR" | tail -n $(($BACKUPS_COUNT - $MAX_BACKUPS)))
        for BACKUP in $OLD_BACKUPS; do
            echo "Removing old backup: $BACKUP"
            rm -rf "$BACKUP_DIR/$BACKUP"
        done
    fi
}

echo "Starting backup process..."
backup_dir

while true; do
    sleep "$INTERVAL"
    check_for_changes_and_backup
    cleanup_old_backups
done 