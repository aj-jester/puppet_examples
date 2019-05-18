#
# Class: ccm_consul
#
class ccm_consul (
  $version           = $ccm_consul::params::version,
  $download_url_base = $ccm_consul::params::download_url_base,
  $user              = $ccm_consul::params::user,
  $group             = $ccm_consul::params::group,
  $restart_on_change = $ccm_consul::params::restart_on_change,
  $install           = $ccm_consul::params::install,
  $base_config       = $ccm_consul::params::base_config,
  $add_config        = $ccm_consul::params::add_config,
  $tls_rpc           = $ccm_consul::params::tls_rpc,
  $enable_backup     = $ccm_consul::params::enable_backup,

) inherits ccm_consul::params {

  if $install {
    include ccm_consul::agent

    if $::tier == 'icinga' and ($::role == 'master' or $::role == 'satellite') {
      # noop
    } else {
      include ccm_consul::facter_to_consul
    }

    if $tls_rpc {
      include ccm_consul::tls_setup
    }

    if $enable_backup {
      include ccm_consul::backup
    }

    anchor { 'ccm_consul::begin': } ->
    Class['ccm_consul::agent'] ->
    anchor { 'ccm_consul::end': }
  }

}
