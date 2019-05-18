#!/usr/bin/env ruby

require 'optparse'
require 'optparse/time'
require 'json'

@options = {}

OptionParser.new do |parser|
  parser.on('-a', '--action=ACTION', String, "

  state_file: Check for valid state file from config.
  last_run_h: Number of hours since the last successful configrr run. (w:2, c:4)
  exec_time_s: Number of seconds taken for Configrr to execute. (w:30, c:60)
  render_time_ms: Number of milliseconds taken for erb to render. (w:200, c:400)
  ") do |action|
    @options[:action] = action
  end

  parser.on('-s', '--state_file=STATE_FILE', String, 'Absolute path to state file.') do |state_file|
    @options[:state_file] = state_file
  end

  parser.on('-w', '--warning=WARNING', Integer, 'Warning threshild INT') do |warning|
    @options[:warning] = warning
  end

  parser.on('-c', '--critical=CRITICAL', Integer, 'Critical threshold INT') do |critical|
    @options[:critical] = critical
  end

  parser.on('-h', '--help', 'Display this message.') do
    puts parser
    exit 0
  end

end.parse!

def read_state_file
  if @options[:state_file].nil?
    puts 'Critical: Pass --state_file argument.'
    exit 2

  elsif File.file?(@options[:state_file])

    begin
      return JSON.parse(File.read(@options[:state_file]))
    rescue JSON::ParserError => e
      puts "Critical: Unable to parse state file #{@options[:state_file]}: #{e.message}"
      exit 2
    end

  else
    puts "Critical: Unable to find state file: #{@options[:state_file]}"
    exit 2
  end
end

case @options[:action]

  when 'state_file'
    configrr_state = read_state_file

    if configrr_state['state_file_status'] == 'config does not exist'
      puts "Critical: state_file_path config not defined in configrr. #{configrr_state['state_file_path']}"
      exit 2

    elsif configrr_state['state_file_status'] == 'state file does not exist'
      puts "Critical: state_file_path #{configrr_state['state_file_path']} does not exist."
      exit 2

    elsif configrr_state['state_file_status'] == 'state file does exist'
      puts "OK: state_file_path #{configrr_state['state_file_path']} does exist."
      exit 0

    else
      puts "Unknown: #{configrr_state['state_file_status']} status unknown."
      exit 3
    end

  when 'last_run_h'
    configrr_state = read_state_file

    last_run_hour = (Time.now.to_i - configrr_state['end_time_s']) / 3600

    warning  = @options[:warning].nil? ? 2 : @options[:warning]
    critical = @options[:critical].nil? ? 4 : @options[:critical]

    if last_run_hour < warning
      puts "OK: Last run time #{last_run_hour}h is within threshold of #{warning}h."
      exit 0
    elsif last_run_hour < critical
      puts "Warning: Last run time #{last_run_hour}h is at or above threshold of #{warning}h."
      exit 1
    else
      puts "Critical: Last run time #{last_run_hour}h is at or above threshold of #{critical}h."
      exit 2
    end

  when 'exec_time_s'
    configrr_state = read_state_file

    warning  = @options[:warning].nil? ? 30 : @options[:warning]
    critical = @options[:critical].nil? ? 60 : @options[:critical]

    if configrr_state['total_time_s'] < warning
      puts "OK: Exec time #{configrr_state['total_time_s']}s is within threshold of #{warning}s."
      exit 0
    elsif configrr_state['total_time_s'] < critical
      puts "Warning: Exec time #{configrr_state['total_time_s']}s is at or above threshold of #{warning}s."
      exit 1
    else
      puts "Critical: Exec time #{configrr_state['total_time_s']}s is at or above threshold of #{critical}s."
      exit 2
    end

  when 'render_time_ms'
    configrr_state = read_state_file

    warning  = @options[:warning].nil? ? 200 : @options[:warning]
    critical = @options[:critical].nil? ? 400 : @options[:critical]

    if configrr_state['render_time_ms'] < warning
      puts "OK: Render time #{configrr_state['render_time_ms']}ms is within threshold of #{warning}ms."
      exit 0
    elsif configrr_state['render_time_ms'] < critical
      puts "Warning: Render time #{configrr_state['render_time_ms']}ms is at or above threshold of #{warning}ms."
      exit 1
    else
      puts "Critical: Render time #{configrr_state['render_time_ms']}ms is at or above threshold of #{critical}ms."
      exit 2
    end

  when 'none'
      puts 'Critical: Please select a valid action.'
      exit 2

  else
    puts "Critical: Invalid action #{@options[:action]}."
    exit 2
  end
