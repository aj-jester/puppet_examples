#
# ccm_puppet::agent
#
class ccm_puppet::agent {

  include ccm_repo::puppet5
  include puppet

  anchor { 'ccm_puppet::agent::begin': } ->

  file { '/etc/pki/ca-trust/source/anchors/puppet5-ca.crt':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/ccm_puppet/certs/ca.pem',
  } ~>

  exec { 'update_puppet5_ca_cert':
    command     => '/bin/update-ca-trust',
    refreshonly => true,
  } ->

  Class['ccm_repo::puppet5'] ->
  Class['::puppet'] ->

  file { '/opt/ccm/bin/runpuppet.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_puppet/runpuppet.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  ccm_profile::cron::hourly { 'runpuppet':
    command => '/opt/ccm/bin/runpuppet.sh',
  } ->

  anchor { 'ccm_puppet::agent::end': }

}
