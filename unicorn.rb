# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/var/psc"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/var/psc/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/logs/unicorn.log"
# stdout_path "/path/to/logs/unicorn.log"
stderr_path "/var/psc/logs/unicorn.log"
stdout_path "/var/psc/logs/unicorn.log"

# Unicorn socket
# listen "/tmp/unicorn.[app name].sock"
listen "/tmp/unicorn.psc.sock"

# Number of processes
worker_processes 4

# Time-out
timeout 30