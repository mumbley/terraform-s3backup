#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: restore.sh <backup-file>"
  exit 1
fi

filename=$1
mongo_password=$(cat /etc/mongo-auth/mongodb-root-password)

mongorestore --host="$MONGO_SVR_ADDR" \
  --username root \
  --password "$mongo_password" \
  --archive="$filename" \
  --authenticationDatabase admin \
  --gzip
