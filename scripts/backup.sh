#!/bin/bash

DATE=$(date +%Y-%m-%d-%H-%M)

BACKUP_DIR=/tmp/wordpress-backups

mkdir -p $BACKUP_DIR


echo "Backing up database..."

docker exec docker-mysql-1 \
mysqldump \
-u wordpress \
-pwordpresspassword \
wordpress \
> $BACKUP_DIR/db-$DATE.sql


echo "Backing up WordPress files..."

docker cp \
docker-wordpress-1:/var/www/html/wp-content \
$BACKUP_DIR/wp-content-$DATE


tar -czf \
$BACKUP_DIR/wp-content-$DATE.tar.gz \
-C $BACKUP_DIR \
wp-content-$DATE


rm -rf $BACKUP_DIR/wp-content-$DATE


echo "Uploading backups to S3..."

aws s3 cp \
$BACKUP_DIR/db-$DATE.sql \
s3://wordpress-backups-maureen/wordpress/


aws s3 cp \
$BACKUP_DIR/wp-content-$DATE.tar.gz \
s3://wordpress-backups-maureen/wordpress/


echo "Backup completed: $DATE"
