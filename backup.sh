#!/bin/bash

# Usage: ./backup_script.sh <directory_to_compress> <backup_retention_count> <aws_access_key_id> <aws_secret_access_key> <s3_bucket_name> <s3_save_path>

DIRECTORY_TO_COMPRESS=$1
RETENTION_COUNT=$2
AWS_ACCESS_KEY_ID=$3
AWS_SECRET_ACCESS_KEY=$4
S3_BUCKET_NAME=$5
S3_SAVE_PATH=$6

# Create a timestamp
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Create a zip file of the directory
ZIP_FILE="${DIRECTORY_TO_COMPRESS}_${TIMESTAMP}.zip"
zip -r $ZIP_FILE $DIRECTORY_TO_COMPRESS

# Configure AWS CLI with provided credentials
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

# Upload the zip file to S3
aws s3 cp $ZIP_FILE s3://$S3_BUCKET_NAME/$S3_SAVE_PATH/

# Cleanup local zip file
rm $ZIP_FILE

# List backups in S3 and keep only the latest $RETENTION_COUNT backups
BACKUPS=$(aws s3 ls s3://$S3_BUCKET_NAME/$S3_SAVE_PATH/ | awk '{print $4}' | sort -r)
COUNT=0

for BACKUP in $BACKUPS; do
    COUNT=$((COUNT + 1))
    if [ $COUNT -gt $RETENTION_COUNT ]; then
        aws s3 rm s3://$S3_BUCKET_NAME/$S3_SAVE_PATH/$BACKUP
    fi
done

echo "Backup and cleanup completed successfully."
