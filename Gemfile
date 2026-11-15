source 'https://rubygems.org'

# Which version of Ruby to use (keep in sync with .ruby-version)
ruby '3.2.2'

# Ruby on Rails framework
gem 'rails', '7.1.6'

# Puma app server
gem 'puma', '>= 6.0'

# Postgress database
gem 'pg'

# For handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors', require: 'rack/cors'

# For converting all incoming JSON to snake_case and outgoing JSON to dashes
gem 'olive_branch'

# For JSON API compliant serialisers
gem 'jsonapi-serializer'

# For token based authentication, specifically Json Web Token (JWT)
gem 'jwt', '~> 2.2'

# For enabling ActiveModel has_secure_password, effectively hiding user passwords from the database
gem 'bcrypt'

# For coloured printing in the console `ap`
gem 'awesome_print'

# Rails default debugger. Stop with `debugger` or `binding.break`.
gem 'debug', groups: %i[development test]

# For seeding the database with modular control and dependencies
gem 'seedbank'

# So we can upload files to Digital Ocean Spaces (S3-compatible)
gem 'aws-sdk-s3'

# For HTTP requests (native Rails does this terribly...)
gem 'faraday'

# For printing curl requests after Faraday requests
gem 'faraday_curl', groups: %i[development]

# For catching N+1 queries
gem 'bullet', groups: %i[development test]

# For listening to file changes
gem 'listen', groups: %i[development]

# For Ruby syntax formatting
gem 'rubocop', groups: %i[development], require: false
gem 'rubocop-rails', groups: %i[development]

# For testing (out-of-the-box with Rails 5)
gem 'minitest', '~> 5.0', groups: %i[test]

# For annotating models and fixtures with schema info.
gem 'annotate', groups: %i[development]

# For sending emails via Postmark
gem 'postmark-rails'

# HACK
# The locked gem is json 3.1.0, pulled in by RuboCop (json >= 2.3 in Gemfile.lock). That version
# dropped quirks_mode, so the call raises ArgumentError: unknown keyword: quirks_mode. The parameter
# parser catches every exception and re-raises the generic ParseError
# TODO: remove after upgrading to a Rails release that is compatible with json 3.
gem 'json', '< 3'
