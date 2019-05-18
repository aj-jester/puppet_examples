class ccm_elastic::clusters::elastic_infra (

){
  include ccm_elastic::common
  include ccm_elastic::search

  if $facts['consul']['hiera']['secondary_role'] == 'kibana' {
    include ccm_elastic::kibana
  }

}
