#!/bin/bash

# Variables
GITHUB_REPO_URL="https://github.com/SumitMatte/EnactOn.git"
CLONE_DIR="/mnt/clone"
BACKUP_DIR="/mnt/backups"  # Assuming you have a dedicated backup directory
GDRIVE_DIR="gdrive:/Backups"
PROJECT_NAME="EnactOn_bckup"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${PROJECT_NAME}_backup_$TIMESTAMP.zip"
LOG_FILE="$BACKUP_DIR/backup_log.txt"
DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3

# Clone or pull the latest code from GitHub
  git clone $GITHUB_REPO_URL $CLONE_DIR
  cd $CLONE_DIR
  echo "Code clone successfully"

# Create Backup
 zip -r $BACKUP_FILE $CLONE_DIR
 echo "Backup created successfully"

# Push to Google Drive
 rclone copy $BACKUP_FILE $GDRIVE_DIR
 echo "Files are uploaded to google drive successfully"

# Send cURL Notification
curl -X POST -H "Content-Type: application/json" -d \
            '{"project": "'"$PROJECT_NAME"'", "date": "'"$TIMESTAMP"'", "status": "BackupSuccessful"}' \

# Rotational Backup
# Keep the backup of the last 7 days
find "$BACKUP_DIR" -type f -name "*.zip" -mtime +$DAILY_KEEP -delete

# Keep the backups of the last 4 Sundays
if [ $(date +%u) -eq 7 ]; then  
    cp "$BACKUP_DIR"/backup-$(date +\%F).zip "$BACKUP_DIR"/weekly-$(date +\%F).zip

    # Delete weekly backups older than 4 weeks
    find "$BACKUP_DIR" -type f -name "*.zip" -mtime +$((7 * $WEEKLY_KEEP)) -delete
fi

# Keep the backups of the last 3 months
if [ $(date +%d) -le 7 ]; then  
    cp "$BACKUP_DIR"/backup-$(date +\%F).zip "$BACKUP_DIR"/monthly-$(date +\%F).zip

    # Delete monthly backups older than 3 months
    find "$BACKUP_DIR" -type f -name "*.zip" -mtime +$((30 * $MONTHLY_KEEP)) -delete
fi
