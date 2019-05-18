#
# Class: ccm_consul::agent
#
class ccm_consul::agent {

  include ccm_consul

  class { '::consul':
    version           => $ccm_consul::version,
    restart_on_change => $ccm_consul::restart_on_change,
    download_url_base => $ccm_consul::download_url_base,
    user              => $ccm_consul::user,
    group             => $ccm_consul::group,
    config_hash       => deep_merge($ccm_consul::base_config, $ccm_consul::add_config),
    require           => Package['unzip'],
  }

}

