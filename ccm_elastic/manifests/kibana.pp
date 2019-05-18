class ccm_elastic::kibana (
){

  include ccm_elastic::common

  class { 'kibana':
    ensure      => $ccm_elastic::common::version,
    config      => $ccm_elastic::common::kibana_config,
    manage_repo => false,
  }

}
