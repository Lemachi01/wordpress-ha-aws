#!/bin/bash

set -e

BUCKET="wordpress-backups-maureen/wordpress"

RESTORE_DIR="/tmp/wordpress-restore"

mkdir -p $RESTORE_DIR


echo "Finding latest backups..."

LATEST_DB=$(aws s3 ls s3://$BUCKET/ | grep db- | sort | tail -1 | awk '{print $4}')

LATEST_FILES=$(aws s3 ls s3://$BUCKET/ | grep wp-content- | sort | tail -1 | awk '{print $4}')


echo "Database backup: $LATEST_DB"
echo "Files backup: $LATEST_FILES"


echo "Downloading database..."

aws s3 cp \
s3://$BUCKET/$LATEST_DB \
$RESTORE_DIR/


echo "Downloading WordPress files..."

aws s3 cp \
s3://$BUCKET/$LATEST_FILES \
$RESTORE_DIR/


echo "Restoring database..."

docker exec -i docker-mysql-1 \
mysql \
-u wordpress \
-pwordpresspassword \
wordpress \
< $RESTORE_DIR/$LATEST_DB


echo "Extracting WordPress files..."

mkdir -p $RESTORE_DIR/wp-content

tar -xzf \
$RESTORE_DIR/$LATEST_FILES \
-C $RESTORE_DIR


echo "Copying WordPress files back..."

docker cp \
$RESTORE_DIR/wp-content \
docker-wordpress-1:/var/www/html/


echo "Restarting WordPress container..."

docker restart docker-wordpress-1


echo "Restore completed successfully."
