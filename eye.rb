working_dir = File.expand_path(File.dirname(__FILE__))

procfile_commands = open("#{working_dir}/Procfile", "r") do |f|
  Hash[f.read.strip.split(/\n/).map do |row|
    row.split(":")
  end.map {|process_name, command| [process_name.to_sym, command] }]
end

Eye.config do
  logger "#{working_dir}/log/eye.log"
end

Eye.application 'meta-legend' do
  working_dir working_dir
  stdall 'log/stdall.eye.log'

  group 'caches' do
    process :json do
      daemonize true
      pid_file 'tmp/pids/eye.caches.json.pid'
      start_command procfile_commands[:cache]
    end

    process :stats do
      daemonize true
      pid_file 'tmp/pids/eye.caches.stats.pid'
      start_command procfile_commands[:stats]
    end
  end

  process :importer do
    daemonize true
    pid_file 'tmp/pids/eye.importer.pid'
    stdall 'log/replay_outcome_importer.log'
    start_command procfile_commands[:importer]
    stop_signals [:TERM, 1.second, :KILL]
  end

  process :sidekiq do
    daemonize true
    pid_file 'tmp/pids/eye.sidekiq.pid'
    stdall 'log/sidekiq.log'
    start_command procfile_commands[:worker]
    stop_signals [:USR1, 0, :TERM, 10.seconds, :KILL]
  end

  process :puma do
    pid_file 'tmp/pids/eye.puma.pid'
    stdall   'log/puma.log'
    daemonize true

    start_command   procfile_commands[:web]
    stop_signals    [:TERM, 5.seconds, :KILL]
    restart_command 'pumactl phased-restart -p {PID}'
    restart_grace   5.seconds
  end
end


# Reference commands

# application-level
  # All options inherits down to the config leafs except `env`, which merging down
  # env 'APP_ENV' => ENV['RAILS_ENV'] || 'development'
  # trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes
  # stdall 'file' # stdout,err logs for processes by default

  # group-level
    # chain grace: 5.seconds # chained start-restart with 5s interval, one by one.

    # process-level
      # pid_path will be expanded with the working_dir
      # when no stop_command or stop_signals, default stop is [:TERM, 0.5, :KILL]
      # default `restart` command is `stop; start`
      # stop_command 'kill -9 {PID}'
      # check :memory, every: 30, below: 300.megabytes, times: 5
      # check :cpu, every: 30, below: 80, times: 3
      # check :memory, every: 30, below: 70.megabytes, times: [3, 5]
      # restart_grace 5.seconds
      # just sleep this until process get up status
      # (maybe enough to puma soft restart)
