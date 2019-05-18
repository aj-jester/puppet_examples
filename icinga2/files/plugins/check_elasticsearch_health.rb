#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'net/http'
require 'json'

options = {}

opts_parser = OptionParser.new do |opts|
  opts.banner = "Usage: check_elasticsearch_cluster.rb [options]"

  opts.on("-i SERVER", "--ip SERVER", String, "Server IP to check") do |server|
    options[:ip] = server
  end

  opts.on("-p PORT", "--port PORT", Integer, "Port to use to connect to server, default 9200") do |port|
    options[:port] = port
  end

  opts.on("-h", "--help", "Display this screen" ) do
    puts opts
    exit 3
  end

end

opts_parser.parse!
mandatory = [:ip]
missing = mandatory.select{ |param| options[param].nil? }
if not missing.empty?
  puts "Missing options: #{missing.join(', ')}"
  puts opts_parser
  exit 3
end

options[:port] = 9200 if options[:port].nil?

begin
  uri = URI("http://#{options[:ip]}:#{options[:port]}/_cluster/health")
  health = JSON.parse(Net::HTTP.get(uri))
rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
  print "HTTP exception: #{e.message}"
  exit 3
rescue JSON::ParserError => e
  print "JSON parse exception: #{e.message}"
  exit 3
end

case health["status"]
  when "green"
    print "Cluster status green"
    exit 0
  when "yellow"
    print "Cluster status yellow"
    exit 2
  when "red"
    print "Cluster status red"
    exit 2
  else
    print "Cluster status unknown"
    exit 3
end
