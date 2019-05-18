#
# icinga2
#
class icinga2 (

  $ensure            = $icinga2::params::ensure,
  $install_module    = $icinga2::params::install_module,
  $node_type         = $icinga2::params::node_type,
  $master_host       = $icinga2::params::master_host,
  $satellite_hosts   = $icinga2::params::satellite_hosts,
  $ticket_salt       = $icinga2::params::ticket_salt,
  $restart_on_change = $icinga2::params::restart_on_change,
  $api_creds         = $icinga2::params::api_creds,
  $cmd_creds         = $icinga2::params::cmd_creds,
  $sudoers           = $icinga2::params::sudoers,

) inherits icinga2::params {

  if $install_module {
    $notify_service = $restart_on_change ? {
      true    => Class['icinga2::service'],
      default => undef,
    }

    anchor { 'icinga2::begin': } ->
    class { 'icinga2::install': notify => $notify_service } ->
    class { 'icinga2::config': notify => $notify_service } ->
    class { 'icinga2::service': } ->
    class { 'icinga2::plugins': } ->
    anchor { 'icinga2::end': }
  }

}
