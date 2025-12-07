#!/bin/bash
set -e

JENKINS_HOME="/var/lib/jenkins"
BACKUP_DIR="/tmp/jenkins-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE="jenkins-backup-$TIMESTAMP.tar.gz"
S3_BUCKET="s3://s3-jenkins-bucket-lee"

# Create backup directory
mkdir -p $BACKUP_DIR

# Stop Jenkins to ensure consistent snapshot (optional but safest)
systemctl stop jenkins

# Create tar archive
tar -czf $BACKUP_DIR/$ARCHIVE -C $JENKINS_HOME .

# Restart Jenkins
systemctl start jenkins

# Upload to S3
aws s3 cp $BACKUP_DIR/$ARCHIVE $S3_BUCKET/

# Cleanup
rm -rf $BACKUP_DIR

echo "Backup completed: $ARCHIVE"
