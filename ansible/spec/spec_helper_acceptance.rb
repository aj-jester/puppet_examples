require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.color = true

  [ :documentation,
    :progress,
  ].map! do |formatter|
    c.add_formatter(formatter)
  end

  c.before :suite do
    hosts.each do |host|

      # Setup environment
      on host, "bash -c 'setenforce 0'"
      on host, "bash -c '/opt/puppetlabs/puppet/bin/r10k deploy environment development -p -v'"
      apply_manifest('include resolv_conf', { :catch_failures => true, :debug => true })
      apply_manifest('include profiles::base', { :catch_failures => true, :debug => true })

      puppet_module_install({
        :module_name        => 'ansible',
        :source             => module_root,
        :target_module_path => '/etc/puppetlabs/code/environments/development/modules',
      })

    end
  end
end

shared_examples "an idempotent resource" do
  it 'should apply with no errors' do
    apply_manifest(pp, { :catch_failures => true, :debug => true })
  end

  it 'should apply a second time without changes', :skip_pup_5016 do
    apply_manifest(pp, { :catch_changes => true, :debug => true })
  end
end
