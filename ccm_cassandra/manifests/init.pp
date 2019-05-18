class ccm_cassandra (
  String $package_ensure     = $ccm_cassandra::params::package_ensure,
  Hash $config_hash          = $ccm_cassandra::params::config_hash,
  Boolean $restart_on_change = $ccm_cassandra::params::restart_on_change,
  String $super_username     = $ccm_cassandra::params::super_username,
  String $super_password     = $ccm_cassandra::params::super_password,
) inherits ccm_cassandra::params {

  $notify_service = $restart_on_change ? {
    true    => Class['ccm_cassandra::service'],
    default => undef,
  }

  anchor { 'ccm_cassandra::begin': } ->
  class { 'ccm_cassandra::install': notify => $notify_service } ->
  class { 'ccm_cassandra::config': notify => $notify_service } ->
  class { 'ccm_cassandra::service': } ->
  anchor { 'ccm_cassandra::end': }
  
}
