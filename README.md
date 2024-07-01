# S3BackupTool

**S3BackupTool** is a shell script tool that compresses a specified directory into a zip file, uploads it to an Amazon S3 bucket, and retains only a specified number of the latest backups.

## Parameters

- `DIRECTORY_TO_COMPRESS`: The directory you want to compress.
- `RETENTION_COUNT`: Number of latest backups to retain.
- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
- `S3_BUCKET_NAME`: The name of your S3 bucket.
- `S3_SAVE_PATH`: The path within the S3 bucket where you want to save the backup.

## Steps

1. Create a timestamped zip file of the specified directory.
2. Configure the AWS CLI with the provided credentials.
3. Upload the zip file to the specified S3 bucket and path.
4. Remove the local zip file after uploading.
5. List all backups in the specified S3 bucket path, sort them in descending order, and retain only the specified number of latest backups by deleting the older ones.

## Usage Example

```sh
./backup_script.sh /path/to/directory 3 your_aws_access_key_id your_aws_secret_access_key your_s3_bucket_name your/s3/save/path
