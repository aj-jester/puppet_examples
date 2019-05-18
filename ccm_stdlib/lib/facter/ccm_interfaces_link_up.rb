# Add a string fact containing all the interfaces with link up, separated by comma
# 2016-07-05 epetrini@collectivei.com Initial Release
Facter.add('ccm_interfaces_link_up') do
  confine :kernel => "Linux"
  setcode do
    # I know this is not the ruby way... bite me!
    %x[ip -o link show | grep -w LOWER_UP | cut -f 2 -d: | sort| tr -d ' ' | egrep -v 'lo|bond|ib|br|veth|docker|vnet' | xargs | tr ' ' ','].chomp
  end
end
