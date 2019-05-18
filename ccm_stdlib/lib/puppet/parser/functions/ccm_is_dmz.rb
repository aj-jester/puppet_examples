# returns the gateway (basically network address with .1)
module Puppet::Parser::Functions
  newfunction(:ccm_is_dmz, :type => :rvalue) do |args|
    ipaddress = args[0]

    ipaddress.match(/10\.4\.26\.|10\.4\.28\.|10\.4\.29\.|10\.4\.31\.|10\.6\.28\.|10\.6\.29\.|10\.6\.31\./) ? true : false
  end
end
