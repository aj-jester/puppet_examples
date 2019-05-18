class ccm_elastic::wazuh_elkstack (
){
  # Pull in all the common ES dependencies
  include ccm_elastic::common

  anchor { 'ccm_elastic::wazuh_elkstack::begin': } ->
  Class['ccm_elastic::common'] ->
  class { 'elasticsearch':
    manage_repo        => false,
    version            => $::ccm_elastic::common::version,
    init_defaults      => $::ccm_elastic::common::init_defaults,
    config             => $::ccm_elastic::common::config,
    jvm_options        => $::ccm_elastic::common::es_jvm_options,
  }                                       ->
  elasticsearch::instance { "${::ccm_elastic::common::clustername}":
    datadir => ["${::ccm_elastic::common::es_data_dir}/${::ccm_elastic::common::clustername}" ],
  } ->

  anchor { 'ccm_elastic::wazuh_elkstack::end': }
}
