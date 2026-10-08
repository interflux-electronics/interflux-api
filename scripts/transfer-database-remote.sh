#!/bin/bash

set -eou pipefail

FILE=$1
DB_PROD=$2
SSH_HOST_2=$3
DEPLOY_USER=bot

echo "----------"
echo "FILE: $FILE"
echo "DB_PROD: $DB_PROD"
echo "SSH_HOST_2: $SSH_HOST_2"
echo "DEPLOY_USER: $DEPLOY_USER"
echo "----------"
echo "Changing directory ..."

cd /var/www/api.interflux.com

echo "✅ Done"
echo "----------"

sudo -u $DEPLOY_USER bash -lc "RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop db:create"

echo "----------"
echo "✅ Reset $SSH_HOST_2 database"
echo "----------"

sudo -u $DEPLOY_USER bash -lc "pg_restore --clean --if-exists --no-owner --no-privileges --dbname=$DB_PROD /var/www/api.interflux.com/db/dumps/$FILE"

echo "----------"
echo "✅ Synced $SSH_HOST_2 database"
echo "----------"