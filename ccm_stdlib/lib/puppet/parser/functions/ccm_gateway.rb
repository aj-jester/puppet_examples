require 'ipaddr'

# returns the gateway (basically network address with .1)
module Puppet::Parser::Functions
  newfunction(:ccm_gateway, :type => :rvalue) do |args|
    ipaddress = args[0]
    netmask = args[1]
    (IPAddr.new(ipaddress).mask(netmask).to_s.split(".").slice(0, 3) + ["1"]) * "."
  end
end
