# The ipaddress and netmask facts are taken by default from the first interface. The problem is that the interfaces
# are alphabetically sorted and docker0 comes before any of ethX, emX, p2pX (bond0 should be fine but currently we're
# not running docker on real hardware so no way to test that).
# So here we define facts that are used in ccm::profile::docker to override values in /etc/environment
#
# 2016-11-16 epetrini@collectivei.com Initial Release

require 'ipaddr'
nic = `ip route | awk '/default/ { print $5 }'`.chomp()
cidr= `ip -o -4 addr show dev "#{nic}" | awk '{print $4; exit}'`.chomp()
net = IPAddr.new(cidr)

ip_addr = cidr.split('/')[0]
ip_mask = net.inspect().split('/')[1].chop()

Facter.add :ccm_ipaddress do
  setcode do
    ip_addr
  end
end

Facter.add :ccm_netmask do
  setcode do
    ip_mask
  end
end
