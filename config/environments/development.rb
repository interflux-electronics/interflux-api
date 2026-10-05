Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true

    # Disable only the "AVOID eager loading" warnings
    Bullet.unused_eager_loading_enable = false

    # Keep other useful warnings
    Bullet.n_plus_one_query_enable = true
    Bullet.counter_cache_enable = true
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  # Note: default value is false, but gave me issues:
  # https://makandracards.com/makandra/528-fixing-a-copy-of-klass-has-been-removed-from-the-module-tree-but-is-still-active
  # https://stackoverflow.com/questions/29636334/a-copy-of-xxx-has-been-removed-from-the-module-tree-but-is-still-active
  # config.eager_load = true
  # https://github.com/rails/rails/issues/33209
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # When developing, do not log. Instead output everything in terminal.
  config.logger = Logger.new($stdout)
  config.log_level = :info
  # config.logger.datetime_format = '%Y-%m-%d %H:%M:%S'
  config.logger.formatter = proc do |severity, _datetime, _progname, msg|
    "#{severity} #{msg}\n"
    # "#{datetime.strftime('%H:%M:%S')} #{severity} #{msg}\n"
  end

  # Return a 404 to all requests who are not these hosts:
  config.hosts = ['localhost', '127.0.0.1']

  # Configure CORS.
  # Note that the Interflux front-end live on different domains than their backend.
  # Therefor cross-origin rules are needed.
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '/v1/public/*',
               headers: :any,
               methods: %i[options get post patch delete]
    end

    allow do
      origins 'localhost:4300'
      resource '/v1/admin/*',
               headers: :any,
               methods: %i[options get post patch delete],
               credentials: true
    end

    allow do
      origins 'localhost:4300'
      resource '/v1/auth/*',
               headers: :any,
               methods: %i[options get post patch delete],
               credentials: true
    end
  end
end
