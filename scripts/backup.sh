#!/usr/bin/env bash

set -e
set -o pipefail

timestamp="$(date -u +"%Y-%m-%d-%H%M%S")-UTC"
server=frankfurt # See ~/.ssh/config
db_prod=interflux_production
db_dev=interflux_development

echo "----------"
echo "Backing up database"
echo "Timestamp: $timestamp"
echo "DB source: $db_prod @ $server"
echo "DB target: $db_dev @ localhost"
echo "----------"
ssh $server "pg_dump -Fc --no-owner --no-privileges --verbose $db_prod" > db/dumps/$db_prod-$timestamp.dump
echo "----------"
echo "✅ Downloaded production database"
echo "----------"
ls -la db/dumps
echo "----------"
RAILS_ENV=development DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop db:create
echo "----------"
echo "✅ Reset local database"
echo "----------"
pg_restore --clean --if-exists --no-owner --no-privileges --dbname=$db_dev db/dumps/$db_prod-$timestamp.dump
echo "----------"
echo "✅ Synced local database with production"
echo "----------"

# In case:
# PG::ObjectInUse: ERROR:  database "interflux_development" is being accessed by other users
# Use:
# psql -d postgres -c "SELECT pid, usename, application_name, client_addr FROM pg_stat_activity WHERE datname = 'interflux_development';"
# Then:
# kill -9 <PID>