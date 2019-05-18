require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|

  c.color = true

  [ :documentation,
    :progress,
  ].map! do |formatter|
    c.add_formatter(formatter)
  end

  environment_dir = File.join(ENV['HOME'], '.tarp', 'r10k', 'environments', 'development')

  unless Dir.exists? environment_dir
    $stderr.puts "Environment directory does not exist. (#{environment_dir})"
    exit 1
  end

  c.module_path  = File.join(environment_dir, 'modules')
  c.manifest_dir = File.join(environment_dir, 'manifests')
end
