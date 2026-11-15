#!/usr/bin/env bash

set -eou pipefail

TIMESTAMP="$(date -u +"%Y-%m-%d-%H%M%S")-UTC"
SSH_HOST=amsterdam
DB_PROD=interflux_production
DB_DEV=interflux_development
FILE=$DB_PROD-$TIMESTAMP.dump

echo "----------"
echo "Backing up database 💽💽"
echo "----------"
echo "TIMESTAMP: $TIMESTAMP"
echo "SSH_HOST: $SSH_HOST"
echo "DB_PROD: $DB_PROD"
echo "DB_DEV: $DB_DEV"
echo "FILE: $FILE"
echo "----------"

ssh $SSH_HOST "pg_dump -Fc --no-owner --no-privileges --verbose $DB_PROD" > db/dumps/$FILE

echo "----------"

ls -la db/dumps

echo "----------"
echo "✅ Downloaded production database from $SSH_HOST to local"
echo "----------"
RAILS_ENV=development DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop db:create
echo "----------"
echo "✅ Reset local database"
echo "----------"
pg_restore --clean --if-exists --no-owner --no-privileges --dbname=$DB_DEV db/dumps/$FILE
echo "----------"
echo "✅ Synced local database with production"
echo "----------"

# In case:
# PG::ObjectInUse: ERROR:  database "interflux_development" is being accessed by other users
# Use:
# psql -d postgres -c "SELECT pid, usename, application_name, client_addr FROM pg_stat_activity WHERE datname = 'interflux_development';"
# Then:
# kill -9 <PID>