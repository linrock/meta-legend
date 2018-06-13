# File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))
working_dir = File.expand_path(File.dirname(__FILE__))

# extract process commands from procfile
procfile = "#{working_dir}/Procfile"
procfile_commands = open(procfile, "r") do |f|
  Hash[f.read.strip.split(/\n/).map do |row|
    row.split(":")
  end.map {|name, cmd| [name.to_sym, cmd] }]
end

Eye.config do
  logger "#{working_dir}/log/eye.log"
end

Eye.application 'meta-legend' do
  # All options inherits down to the config leafs except `env`, which merging down

  working_dir working_dir
  stdall 'log/processes.eye.log' # stdout,err logs for processes by default
  # env 'APP_ENV' => ENV['RAILS_ENV'] || 'development'
  # trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

  group 'caches' do
    # chain grace: 5.seconds # chained start-restart with 5s interval, one by one.
    process :json do
      pid_file 'tmp/pids/caches.json.pid' # pid_path will be expanded with the working_dir
      # stdall 'log/eye.caches.log'

      start_command procfile_commands[:cache]
      stop_signals [:TERM, 1.second, :KILL]
      # when no stop_command or stop_signals, default stop is [:TERM, 0.5, :KILL]
      # default `restart` command is `stop; start`
      daemonize true
    end

    process :stats do
      pid_file 'tmp/pids/caches.stats.pid'
      # stdall 'log/eye.caches.log'

      start_command procfile_commands[:stats]
      stop_signals [:TERM, 1.second, :KILL]
      # stop_command 'kill -9 {PID}'
      daemonize true
    end
  end

  process :importer do
    pid_file "tmp/pids/eye.importer.pid"
    # stdall "log/eye.importer.log"

    start_command procfile_commands[:importer]
    stop_signals [:TERM, 1.second, :KILL]
    daemonize true
  end

  process :sidekiq do
    pid_file "tmp/pids/eye.sidekiq.pid"
    # stdall "log/eye.sidekiq.log"

    start_command procfile_commands[:worker]
    stop_signals [:USR1, 0, :TERM, 10.seconds, :KILL]
    daemonize true
    # check :cpu, every: 30, below: 100, times: 5
    # check :memory, every: 30, below: 300.megabytes, times: 5
  end

  process :puma do
    pid_file 'tmp/pids/eye.puma.pid'
    stdall 'log/eye.puma.log'

    start_command procfile_commands[:web]
    stop_signals [:TERM, 5.seconds, :KILL]
    restart_command 'pumactl phased-restart -p {PID}'
    # just sleep this until process get up status
    # (maybe enought to puma soft restart)
    restart_grace 5.seconds
    daemonize true
    # check :cpu, every: 30, below: 80, times: 3
    # check :memory, every: 30, below: 70.megabytes, times: [3, 5]
  end
end
