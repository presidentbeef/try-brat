# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/var/www/try.brat-lang.org/"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/www/try.brat-lang.org/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/logs/unicorn.log"
# stdout_path "/path/to/logs/unicorn.log"
stderr_path "/var/www/try.brat-lang.org/logs/unicorn.log"
stdout_path "/var/www/try.brat-lang.org/logs/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.brat.sock"

# Number of processes
worker_processes 4

# Time-out
timeout 30
