#
# class: ccm_mongodb
#
class ccm_mongodb (

  Enum['server', 'mongos'] $package_name       = $ccm_mongodb::params::package_name,
  String $package_ensure                       = $ccm_mongodb::params::package_ensure,
  Hash $config_hash                            = $ccm_mongodb::params::config_hash,
  Boolean $restart_on_change                   = $ccm_mongodb::params::restart_on_change,
  Optional[String] $security_authorization_key = $ccm_mongodb::params::security_authorization_key,
  String $admin_username                       = $ccm_mongodb::params::admin_username,
  Optional[String] $admin_password             = $ccm_mongodb::params::admin_password,

) inherits ccm_mongodb::params {

  $notify_service = $restart_on_change ? {
    true    => Class['ccm_mongodb::service'],
    default => undef,
  }

  anchor { 'ccm_mongodb::begin': } ->
  class { 'ccm_mongodb::install': notify => $notify_service } ->
  class { 'ccm_mongodb::config': notify => $notify_service } ->
  class { 'ccm_mongodb::service': } ->
  anchor { 'ccm_mongodb::end': }

}
