# Backup Script

## Overview

This script automates the process of backing up a source directory to a backup directory at regular intervals. It checks for changes in the source directory before creating new backups to save space and avoid redundant copies. Additionally, it ensures that only a specified number of backups are retained by deleting the oldest backups when necessary.

---

## Usage

Run the script with the following arguments:

```bash
./backup.sh <sourcedirectory> <backupdirectory> <interval-secs> <max-backups>
```

- `<sourcedirectory>`: Path to the directory you want to back up.
- `<backupdirectory>`: Path to the directory where backups will be stored.
- `<interval-secs>`: Time interval (in seconds) between backup checks.
- `<max-backups>`: Maximum number of backups to retain.

---

## Example

To back up `/home/user/documents` every 60 seconds, store backups in `/home/user/backups`, and retain up to 5 backups:

```bash
./backup.sh /home/user/documents /home/user/backups 60 5
```

---

## Features

1. **Automatic Directory Creation**:  
   If the specified backup directory does not exist, the script will create it automatically.

2. **Change Detection**:  
   The script detects changes in the source directory by comparing file metadata (size, permissions, etc.). If no changes are detected, it skips the backup.

3. **Backup Cleanup**:  
   Old backups are automatically removed when the number of backups exceeds the specified limit.

4. **Time-Stamped Backups**:  
   Each backup is stored in a directory named with a timestamp (e.g., `2024-06-18-12-00-00`).

5. **Directory Information**:  
   A file named `directory-info.last` is stored with each backup, containing metadata of the source directory for change detection.

---

## How It Works

1. **Initial Backup**:  
   When the script starts, it creates the first backup of the source directory.

2. **Continuous Monitoring**:  
   The script runs in an infinite loop and checks for changes in the source directory at the specified interval.

3. **Change Detection**:  
   - The script compares the metadata of the current source directory (`directory-info.new`) with the last backup's metadata (`directory-info.last`).
   - If changes are detected, a new backup is created.

4. **Cleanup**:  
   If the number of backups exceeds the specified limit, the oldest backups are deleted.

---

## Script Output

During execution, the script will print messages indicating its actions, such as:

- "Backing up `<source>` to `<destination>`"
- "No changes detected, skipping backup."
- "Changes detected, backing up..."
- "Removing old backup: `<backup_name>`"

---

## Notes

- Ensure you have the necessary permissions to access the source and backup directories.
- Use `Ctrl+C` to stop the script manually.

---

## Requirements

- A Unix-like operating system (e.g., Linux, macOS).
- Bash shell (`#!/bin/bash`).
- Basic tools: `mkdir`, `cp`, `ls`, `rm`, and `date`.

---

## License

This script is free to use and modify.

--- 


