#!/usr/bin/env ruby

require 'facter'

exclude_mountpoints = [
  '^\/dev.*',
  '.*\/overlay\/.*',
  '.*\/devicemapper\/.*',
  '^\/sys.*',
  '^\/boot.*',
  '^\/run.*'
]

# on puppet4 (ie: latest facter) the mountpoints is a hash, split cannot be applied
#all_mountpoints = Facter.value(:mountpoints).split(",")
all_mountpoints = Facter.value(:mountpoints).keys

monitorable_mountpoints = Array.new

all_mountpoints.each do |mnt|

  @monitorable = true

  exclude_mountpoints.each do |ex_mnt|
    if mnt =~ /#{ex_mnt}/
      @monitorable = false
      break
    end
  end

  monitorable_mountpoints += [mnt] if @monitorable
end

Facter.add('ccm_mountpoints') do
  confine :kernel => "Linux"
  setcode do
    monitorable_mountpoints.join(",")
  end
end
