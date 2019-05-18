#!/usr/bin/env ruby
# 2015-06-30 epetrini: shamelessly copied from ::ipmi class with some adaptation for our cases
#
# This assume that ipmitool and freeipmi packages are installed
class CCM_IPMIChannel
  public
  def initialize( params = {} )
    @channel_nr = params.fetch(:channel_nr)
    @preferred_channel = params.fetch(:preferred_channel, 1)
    @has_facts = false
  end

  def load_facts
    ipmitool_output = `env - $(which ipmitool) lan print #{@channel_nr} 2>&1`
    parse_ipmitool_output ipmitool_output
    if ipmitool_output =~ /Invalid channel/ then
      return false
    elsif not @has_facts
      Facter.debug(ipmitool_output)
      return false
    else
      return true
    end
  end

  private

  def parse_ipmitool_output ipmitool_output
    ipmitool_output.each_line do |line|
      case line.strip
      when /^IP Address\s*:\s+(\S.*)/
        add_ipmi_fact("ipaddress", $1)
        begin
          hostname=Resolv.new.getname($1)
        rescue Resolv::ResolvError
          hostname=$1
        ensure
          add_ipmi_fact("hostname", hostname)
        end
      when /^IP Address Source\s*:\s+(\S.*)/
        add_ipmi_fact("ipaddress_source", $1)
      when /^Subnet Mask\s*:\s+(\S.*)/
        add_ipmi_fact("subnet_mask", $1)
      when /^MAC Address\s*:\s+(\S.*)/
        add_ipmi_fact("macaddress", $1)
      when /^Default Gateway IP\s*:\s+(\S.*)/
        add_ipmi_fact("gateway", $1)
      end
    end
  end

  def add_ipmi_fact name, value
    fact_names = []
    if @channel_nr == @preferred_channel then fact_names.push("ccm_bmc_#{name}") end
    fact_names.push("ccm_bmc#{@channel_nr}_#{name}")
    fact_names.each do |name|
      Facter.add(name) do
        confine :kernel => "Linux"
        setcode do
          value
        end
      end
    end
    @has_facts = true
  end
end

# no need to bother on VMs
if Facter.value(:is_virtual) == false and Facter.value(:type) != 'Desktop'

  bmc_manufacturer = %x[bmc-info | awk -F': ' '/^Manufacturer.ID/ {print $NF}'].strip
  case bmc_manufacturer
  when "Quanta Computer Inc. (7244)"
    preferred_channel=3
  when "Intel Corporation (343)", "343"
    preferred_channel=3
  when "Hewlett-Packard (11)"
    preferred_channel=2
  else
    preferred_channel=1
  end

  Facter.add('ccm_bmc_manufacturer') do
    confine :kernel => "Linux"
    setcode do
      bmc_manufacturer
    end
  end

  lan_channels = Array.new
  for channel_nr in 1..15
    if CCM_IPMIChannel.new(:channel_nr => channel_nr, :preferred_channel => preferred_channel).load_facts
      lan_channels.push(channel_nr)
    end
  end

  Facter.add('ccm_bmc_lan_channels') do
    confine :kernel => "Linux"
    setcode do
      lan_channels * ","
    end
  end

  Facter.add('ccm_bmc_nchannels') do
    confine :kernel => "Linux"
    setcode do
      lan_channels.length
    end
  end

  # Corrective action: Some vendors (Quanta, Intel) have different BMC with different channels numbering.
  # In this case, if the preferred channel is not valid, we take the first channel with an IP
  if ! lan_channels.include?(preferred_channel)
    lan_channels.each do |c|
      if Facter.value("ccm_bmc#{c}_ipaddress") != "" and Facter.value("ccm_bmc#{c}_ipaddress") != "0.0.0.0"
        preferred_channel=c
        break if CCM_IPMIChannel.new(:channel_nr => c, :preferred_channel => preferred_channel).load_facts
      end
    end
  end

  Facter.add('ccm_bmc_preferred_channel') do
    confine :kernel => "Linux"
    setcode do
      preferred_channel
    end
  end

  Facter.add('ccm_bmc_ok') do
    confine :kernel => "Linux"
    setcode do
      if Facter.value(:ccm_bmc_hostname) =~ /.*ccmteam.com/ and Facter.value(:ccm_bmc_hostname) !~ /^pool-dyn/
        true
      else
        false
      end
    end
  end
end
