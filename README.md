# DirectoryBackup: Bash Script for Creating Backups

This is a Bash script that creates backups of important files and directories in a project. It checks for existing backup directories and removes the oldest one if there are already 4. It then creates a new directory with a name that includes the word "backup" and a number that is one higher than the highest existing backup directory.

## Usage

To use this script, first make the script executable and simply run it from the command line in the project directory:

```Bash
chmod +x install_python38.sh
```
```Bash
./do-backup.sh
```

The script will check for existing backup directories and remove the oldest one if necessary. It will then create a new backup directory and move all non-zip, non-backup, and non-readme files to the new directory.

## Notes

- This script assumes that all important files and directories are located in the same directory as the script.
- The script will only keep up to 4 backup directories at a time. You can change this value by modifying the conditional statement that checks for the number of existing backup directories.
- The script excludes files with the extensions `.zip`, `.backup`, and `README` from the backup process. You can modify this list by changing the regular expression in the `backup_files` function.
- If the script encounters any errors during the backup process, it will exit with an error code of 1.
