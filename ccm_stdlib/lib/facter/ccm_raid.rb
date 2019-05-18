#!/usr/bin/env ruby

require 'facter'

if Facter.value(:is_virtual) == false and Facter.value(:type) != 'Desktop'

  lspci_output = %x(/sbin/lspci | grep RAID)

  # Check for Hardware raid
  raid_type = if lspci_output =~ /Adaptec/
    'adaptec'
  elsif lspci_output =~ /MegaRAID/
   'megaraid'
  elsif lspci_output =~ /Smart Array/
    'smartarray'

  # If no hardware raid check for software raid
  elsif File.directory?("/sys/devices/virtual/block/md0")
    'mdadm'
  else
    'none'
  end

  Facter.add('ccm_raid') do
    confine :kernel => "Linux"
    setcode do
      raid_type
    end
  end
end
