environment ENV['RAILS_ENV'] || 'production'
pidfile '/usr/local/cityprice/current/shared/tmp/pids/puma.pid'
stdout_redirect '/usr/local/cityprice/current/shared/tmp/log/stdout', '/usr/local/cityprice/current/shared/tmp/log/stderr'
threads 2, 16
workers 2
bind 'unix:///usr/local/cityprice/current/shared/tmp/socket/puma.sock'
# daemonize true
