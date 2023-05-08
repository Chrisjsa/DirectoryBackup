#!/bin/bash

# Variables
BACKUP_NAME="backup"
EXISTING_DIRS=$(find . -type d -name "$BACKUP_NAME-*" -printf "%T@ %p\n" | sort -n | cut -d ' ' -f 2-)
NUM_DIRS=$(echo "$EXISTING_DIRS" | wc -l)
LAST_DIR=$(echo "$EXISTING_DIRS" | tail -n 1)
HIGHEST_NUM=$(echo "$EXISTING_DIRS" | sed 's/.*backup-\([0-9]*\)/\1/' | sort -rn | head -n 1)

echo "There are $NUM_DIRS backup directories"
echo "Last backup directory: $LAST_DIR"

# If there are already 4 backup directories, delete the oldest one and get the highest number
if [ "$NUM_DIRS" -ge 4 ]; then
  # Delete the oldest directory
  OLDEST_DIR=$(echo "$EXISTING_DIRS" | head -n 1)
  if [ -d "$OLDEST_DIR" ]; then
    rm -rf -- "$OLDEST_DIR"
    echo "Deleted the oldest directory: $OLDEST_DIR"
  else
    echo "Error: oldest directory not found: $OLDEST_DIR"
    exit 1
  fi
  # Get the highest number
  HIGHEST_NUM=$((HIGHEST_NUM+1))
else
  # Get the highest number
  HIGHEST_NUM=$(echo "$EXISTING_DIRS" | sed 's/.*backup-\([0-9]*\)/\1/' | sort -rn | head -n 1)
fi

# Create the backup directory with the highest number + 1
NEW_DIR_NAME="$BACKUP_NAME-$((HIGHEST_NUM+1))"
if mkdir -- "$NEW_DIR_NAME"; then
  echo "Created directory $NEW_DIR_NAME"
else
  echo "Error: could not create directory: $NEW_DIR_NAME"
  exit 1
fi

# Function to backup files
backup_files() {
  local TARGET_DIR="$1"
  echo "Backing up files to $TARGET_DIR"
  shopt -s extglob
  if OUTPUT=$(mv -v !(*.zip|*backup*|README*) -- "$TARGET_DIR"/ 2>&1); then
    echo "$OUTPUT"
    echo "Files backed up"
  else
    echo "Error: could not backup files: $OUTPUT"
    exit 1
  fi
}

# Backup files to new directory
backup_files "$NEW_DIR_NAME"