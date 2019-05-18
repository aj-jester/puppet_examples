class ccm_profile::firewalld {

  include ::firewalld

  firewalld_service { 'Allow SSH':
    ensure  => 'present',
    service => 'ssh',
    zone    => 'public',
  }

  firewalld_service { 'Allow dhcpv6-client':
    ensure  => 'present',
    service => 'dhcpv6-client',
    zone    => 'public',
  }

  firewalld_service { 'Allow snmp':
    ensure  => 'present',
    service => 'snmp',
    zone    => 'public',
  }

  firewalld_port { 'Allow Icinga2 TCP 5665':
    ensure   => present,
    zone     => 'public',
    port     => 5665,
    protocol => 'tcp',
  }

  firewalld_port { 'Allow Consul TCP 8500':
    ensure   => present,
    zone     => 'public',
    port     => 8500,
    protocol => 'tcp',
  }

  firewalld_port { 'Allow Consul TCP 8600':
    ensure   => present,
    zone     => 'public',
    port     => 8600,
    protocol => 'tcp',
  }

  firewalld_port { 'Allow Consul UDP 8600':
    ensure   => present,
    zone     => 'public',
    port     => 8600,
    protocol => 'udp',
  }

  firewalld_port { 'Allow Consul TCP 8301':
    ensure   => present,
    zone     => 'public',
    port     => 8301,
    protocol => 'tcp',
  }

  firewalld_port { 'Allow Consul UDP 8301':
    ensure   => present,
    zone     => 'public',
    port     => 8301,
    protocol => 'udp',
  }

}
