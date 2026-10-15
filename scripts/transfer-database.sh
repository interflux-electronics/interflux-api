#!/usr/bin/env bash

set -eou pipefail

TIMESTAMP="$(date -u +"%Y-%m-%d-%H%M%S")-UTC"
SSH_HOST_1=frankfurt # source
SSH_HOST_2=amsterdam # target
DB_PROD=interflux_production
DB_DEV=interflux_development
FILE=$DB_PROD-$TIMESTAMP.dump

echo "----------"
echo "Backing up database 💽💽"
echo "----------"
echo "TIMESTAMP: $TIMESTAMP"
echo "SSH_HOST_1: $SSH_HOST_1"
echo "SSH_HOST_2: $SSH_HOST_2"
echo "DB_PROD: $DB_PROD"
echo "DB_DEV: $DB_DEV"
echo "FILE: $FILE"
echo "----------"

ssh $SSH_HOST_1 "pg_dump -Fc --no-owner --no-privileges --verbose $DB_PROD" > db/dumps/$FILE

echo "----------"

ls -la db/dumps

echo "----------"
echo "✅ Downloaded production database from $SSH_HOST_1 to local"
echo "----------"

scp db/dumps/$FILE $SSH_HOST_2:/var/www/api.interflux.com/db/dumps/

echo "----------"
echo "✅ Uploaded production database to $SSH_HOST_2"
echo "----------"

scp scripts/transfer-database-remote.sh $SSH_HOST_2:~/

echo "----------"
echo "✅ Uploaded script to $SSH_HOST_2"
echo "----------"

ssh -t $SSH_HOST_2 "~/transfer-database-remote.sh $FILE $DB_PROD $SSH_HOST_2"

echo "----------"
echo "⛵️"
echo "----------"