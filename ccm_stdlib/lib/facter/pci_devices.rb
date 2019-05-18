# 20130520 ic
# https://github.com/kumina/fact-pci_devices/blob/master/pci_devices.rb
# support CentOS 5 (new regex, remove -k flag and driver fact)
# remove OS test
# simplify fact name
# add raid_count

# This script is only tested on Debian (Lenny and Squeeze), if you
# have any improvements, send a pull request, ticket or email.
# The latest version of this script is available on github at
# https://github.com/kumina/fact-pci_devices

def add_fact(fact, code)
  Facter.add(fact) { setcode { code } }
end

lspci = "/sbin/lspci"

if FileTest.exists?(lspci)
  # Create a hash of ALL PCI devices, the key is the PCI slot ID.
  # { SLOT_ID => { ATTRIBUTE => VALUE }, ... }
  slot=""
  # after the following loop, devices will contain ALL PCI devices and the info returned from lspci
  devices = {}
  #%x{#{lspci} -v -mm -k}.each_line do |line|
  %x{#{lspci} -v -mm}.each_line do |line|
    if not line =~ /^$/ # We don't need to parse empty lines
      splitted = line.split(/\t/)
      # lspci has a nice syntax:
      # ATTRIBUTE:\tVALUE
      # We use this to fill our hash
      #if splitted[0] =~ /^Slot:$/
      if line =~ /^[Device|Slot]+:\t[0-9a-f]+:[0-9a-f]+\.[0-9]$/
        slot=splitted[1].chomp
        devices[slot] = {}
      else
        # The chop is needed to strip the ':' from the string
        devices[slot][splitted[0].chop] = splitted[1].chomp
      end
    end
  end

  # To create your own facts, edit the following code:
  raid_counter = 0
  devices.each_key do |a|
    case devices[a].fetch("Class")
    when /^RAID/
      add_fact("raid_vendor#{raid_counter}", "#{devices[a].fetch('Vendor')}")
      #add_fact("raidcontroller#{raid_counter}_vendor", "#{devices[a].fetch('Vendor')}")
      #add_fact("raidcontroller#{raid_counter}_driver", "#{devices[a].fetch('Driver')}")
      raid_counter += 1
    end
  end
  add_fact("raid_count", "#{raid_counter}")
end
