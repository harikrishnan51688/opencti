#!/bin/bash
set -euo pipefail

BACKUP_DIR="/opt/backups/opencti/20260805_120334"
S3_BUCKET="s3://opencti-bkup"

echo "Uploading $BACKUP_DIR to $S3_BUCKET..."

aws s3 cp \
    "$BACKUP_DIR" \
    "${S3_BUCKET}/20260805_120334/" \
    --recursive

echo "Upload complete."
