#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "usage: bachup.sh <database>"
    exit 1
fi

database=$1
mongo_password=$(cat /etc/mongo-auth/mongodb-root-password)
backup_file="${MONGO_SVR_ADDR%%:*}"
backup_path="/mnt"

dump() {
    mongodump --host="$REPLICA_SET/$MONGO_SVR_ADDR" \
        --db=$database \
        -u root \
        -p "$mongo_password" \
        --archive="$backup_path/$backup_file" \
        --gzip \
        --authenticationDatabase admin
}

s3copy() {
    s3_timestamped_file="$backup_file-$(date +'%Y%m%d%H%M').tgz"
    mv "$backup_path/$backup_file" "$backup_path/$s3_timestamped_file"
    aws s3 cp "$backup_path/$s3_timestamped_file"  "s3://$S3_BACKUP_BUCKET/$s3_timestamped_file"
}

if [[ -z $S3_BACKUP_BUCKET ]] || [[ -z $DEPLOYMENT_NAME ]] || [[ -z $MONGO_SVR_ADDR ]]; then
    echo "environment variables unset"
    exit 1
fi

dump
s3copy