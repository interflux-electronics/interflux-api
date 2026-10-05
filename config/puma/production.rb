#!/usr/bin/env puma

environment 'production'

# Make Puma run in the background by daemonizing it after calling `puma -e production`.
#
# Note: We do not upgrade to Puma v5 because it removes the option for daemonizing Puma:
# https://github.com/puma/puma/blob/master/docs/deployment.md#should-i-daemonize
# TODO: We should monitor and revive our Puma process with something like monit:
# https://www.monterail.com/blog/2015/deployment-setup-for-jruby-rails-app-with-puma-mina-and-monit
#
# daemonize removed in Puma 5+; manage the process with systemd/monit instead
# daemonize true

# By defining the amount of workers we enable "clustered mode". In clustered
# mode one mother process will spawn X amount of child processes (workers)
# effectively allowing us to leverage each CPU cores for higher concurrency.
# The recommended number of workers is the same amount of CPU cores your server
# has (never more). With 2 workers, you should see 3 puma pids when running:
# `ps aux | grep puma`. One is the mother, 1 mother and 2 are the children.
# Killing the mother also ends the child processes. Killing a child process will
# cause them to respawn with a new pid.
workers 2

# Per worker spin up 0 to 5 threads based on how much traffic is present. With
# 2 workers we would have 0 to 10 threads running + internally created threads.
# Each thread takes up RAM space, thus adjust these to optimise RAM usage.
threads 0, 5

# Where to store the Puma socket.
# This is the socekt Nginx will forward requests to and expects responses from.
bind 'unix:///var/www/rails.api.interflux.com/puma/server.sock'

# Where to store the Puma control socket.
# This socket allows us to interact with Puma (start, stop, status, ...)
activate_control_app 'unix:///var/www/rails.api.interflux.com/puma/control.sock', auth_token: '12345'

# Where to store Pumag pid, state and logs.
pidfile '/var/www/rails.api.interflux.com/puma/server.pid'
state_path '/var/www/rails.api.interflux.com/puma/server.state'
stdout_redirect '/var/www/rails.api.interflux.com/puma/stdout.log', '/var/www/rails.api.interflux.com/puma/stderr.log', true

# Which Rails build to serve.
# Note that this is a symlinked folder pointing at the latest build.
directory '/var/www/rails.api.interflux.com/'

# Verifies that all workers have checked in to the master process within the
# given timeout. If not the worker process will be restarted. This is not a
# request timeout, it is to protect against a hung or dead process. Setting this
# value will not protect against slow requests. Default value is 60 seconds.
worker_timeout 60

# A description appended to the Unix process as seen in `ps aux`.
tag 'Puma server for Interflux API (production)'
