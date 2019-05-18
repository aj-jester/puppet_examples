class ccm_consul::tls_setup {

# Class to setup TLS RPC comms for consul. This uses the Puppet CA and system certs.
# CA should already be copied to ca-trust, and updated for the system as a whole
# Copy Cert and Key to a secure location in consul

  file { '/etc/consul/ssl':
    ensure => directory,
    owner  => 'consul',
    group  => 'consul',
    mode   => '0640',
    } ->

  file { "/etc/consul/ssl/${::fqdn}.crt":
    ensure => present,
    owner  => 'consul',
    group  => 'consul',
    mode   => '0640',
    source => "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
  } ->

  file { "/etc/consul/ssl/${::fqdn}.key":
    ensure => present,
    owner  => 'consul',
    group  => 'consul',
    mode   => '0640',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
  }
}
