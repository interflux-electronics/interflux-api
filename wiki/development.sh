
# SETUP LOCAL (MAC)

brew update
brew install rbenv ruby-build

# As long brew exists in the PATH, then rbenv will exist as well and all next
# steps are not necessary?

# eval "$(/opt/homebrew/bin/brew shellenv)"
# echo "$PATH"

# Someone suggest to then add `rbenv` to path, but no need...

# set --universal fish_user_paths $fish_user_paths ~/.rbenv/shims

# Instead:

# rbenv init

# Suggest to add the following to Fish config:

# atom ~/.config/fish/config.fish
# status --is-interactive; and source (rbenv init -|psub)

#  Install and start Postgres

brew install postgresql
brew services start postgresql@14

# Clone repo

git clone git@github.com:janwerkhoven/api.interflux.com.git
cd api.interflux.com

# Install Ruby

rbenv install -s
rbenv rehash

# When you run
ruby -v

# Your Mac will likely show
# ruby 2.6.10p210 (2022-04-12 revision 67958) [universal.arm64e-darwin22]
# Which is the version Mac is locked down to and not the one we use in our repository.

# By adding the rbenv directory to the $PATH
set --universal fish_user_paths $fish_user_paths ~/.rbenv/shims
# Then
ruby -v
# Should output
# ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [arm64-darwin21]
# inside our repo and
# ruby 2.6.10p210 (2022-04-12 revision 67958) [universal.arm64e-darwin22]
# outside our repo.

# Before you can install gems you may need to claim ownership over these directories:
# TODO: find bettter way
sudo chown -R jw /Library/Ruby/Gems/
sudo chown -R jw /usr/local/bin/

# Install gems
gem install bundler
gem install rails
bin/bundle install

# Fire up local database

bin/rails db:drop;
bin/rails db:create
bin/rails db:migrate

# Create backup of production database
# Sync production database down to development

scripts/backup.sh

# Serve Rails

bin/rails s

# ---------

# COMMON COMMANDS

# Open Rails console

bin/rails c

# Generate common route-controller-model-serialiser-test scaffold

bin/rails generate custom_scaffold products --version=v1 --scope=public
bin/rails generate custom_scaffold product_documents --version=v1 --scope=admin

# Seed database (outdated)

bin/rails db:seed
bin/rails db:seed:documents
bin/rails db:seed:products

# Seed database with fixtures (outdated)

bin/rails db:fixtures:load FIXTURES=articles

# Drop database and start over (outdated)

bin/rails db:environment:set RAILS_ENV=development;
bin/rails db:drop;
bin/rails db:create;
bin/rails db:migrate;
bin/rails db:seed

# Roll back a migration:

bin/rails db:rollback STEP=1

# Test user login

curl \
-X POST \
-H "Content-Type: application/vnd.api+json" \
-d '{ "email": "j.werkhoven@interflux.com", "password": 12345678 }' \
http://localhost:3000/v1/admin/auth/login

# Add auth token

curl \
-X GET \
-H "Content-Type: application/vnd.api+json" \
-H "Authorization: $token" \
http://localhost:3000/v1/admin/leads

# Sanity check:

curl \
-X GET \
-H "Content-Type: application/vnd.api+json" \
http://localhost:3000/sanity-check

# ---------

# USERS

# First set the development environment flag
export RAILS_ENV=development

# Create user
bin/rails user:create email=foo@bar password=1234 first_name=John last_name=Doe

# Update password
bin/rails user:password email=foo@bar password=12345

# Delete user
bin/rails user:delete email=foo@bar

# ---------

# WEBP

# The webp-ffi gem will likely blow up on an M1 or M2 Mac.
# The issue and solution were described here:
# https://github.com/myfoodlink/myfoodlink/wiki/Development-Environment-Setup#:~:text=solution%20was%20described-,here,-.
# In short, follow the commands below to resolve:

# 1. Set CPATH and LIBRARY_PATH as global variables.
# 2. Add gem 'webp-ffi' to Gemfile
# 3. Install bundle.

# ZSH
export CPATH=/opt/homebrew/include/
export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib/

# Fish
set -x CPATH /opt/homebrew/include/
set -x LIBRARY_PATH "/opt/homebrew/lib/"

bin/bundle install


# Edit credentials

```sh
EDITOR="code --wait" bin/rails credentials:edit --environment production
EDITOR="code --wait" bin/rails credentials:edit --environment development
EDITOR="code --wait" bin/rails credentials:edit --environment test
```