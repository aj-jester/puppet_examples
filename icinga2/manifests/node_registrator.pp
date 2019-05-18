#
# icinga2::node_registrator
#
class icinga2::node_registrator {

  include icinga2

  $master_host = $icinga2::master_host
  $node_type   = $icinga2::node_type
  $api_creds   = $icinga2::api_creds

  file { '/opt/ccm/bin/icinga2_node_registrator.sh':
    ensure  => present,
    owner   => 'icinga',
    group   => 'icinga',
    mode    => '0750',
    content => template('icinga2/icinga2_node_registrator.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  exec { 'Registering node with master':
    command => '/opt/ccm/bin/icinga2_node_registrator.sh',
    user    => 'icinga',
    creates => '/var/lib/icinga2/certs/trusted-master.crt',
  }

}
