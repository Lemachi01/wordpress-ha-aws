#!/bin/bash

# Timestamp
DATE=$(date +%Y-%m-%d-%H-%M)

# Create backup directory
mkdir -p /tmp/wordpress-backups

# Database backup
mysqldump \
-u wordpress \
-pwordpresspassword \
wordpress \
> /tmp/wordpress-backups/db-$DATE.sql

# Compress WordPress files
tar -czf /tmp/wordpress-backups/wp-content-$DATE.tar.gz \
/var/www/html/wp-content

# Upload database backup
aws s3 cp \
/tmp/wordpress-backups/db-$DATE.sql \
s3://wordpress-backups/

# Upload WordPress files
aws s3 cp \
/tmp/wordpress-backups/wp-content-$DATE.tar.gz \
s3://wordpress-backups/

echo "Backup completed: $DATE"
