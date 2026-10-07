
rails_env = ENV.fetch("RAILS_ENV", "development")

environment rails_env

pidfile ENV.fetch('PIDFILE') { 'tmp/pids/server.pid' }

# The production server has 2 CPU cores and 4GB RAM
if rails_env == "production"
  # One worker per CPU core
  workers 2

  # 5 threads on 2 cores, means 10 concurrent Rails requests in flight
  # we keep min and max the same to prevent resizing for optimal response times over RAM
  # never exceed the database pool size in database.yml!
  threads 5, 5

  # Boot Rails once in the master and fork.
  # This saves hundreds of MB of RAM versus two cold boots.
  preload_app!

  # Each fork copies the master's database connection, which is unsafe.
  # Instead create a new database connection per fork with these 2 hooks:
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end
  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
  
  # serve over socket instead of port
  bind 'unix:///var/www/api.interflux.com/tmp/sockets/puma.sock'
end

if rails_env == "development"
  # single mode, one process, no master, no fork
  # necessary for code reloading to to work
  # workers are wasted RAM on laptop
  workers 0
  
  # arbitrary
  threads 3, 3

  # serve on port 3000
  port ENV.fetch('PORT', 3000)
end

# Run the Solid Queue supervisor inside of Puma for single-server deployments.
# plugin :solid_queue if ENV['SOLID_QUEUE_IN_PUMA']