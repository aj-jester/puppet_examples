# Elasticsearch role - Performance Testing Edition
class ccm_role::site_elk {

  # Pull in our Elastic Moules for this role
  include ccm_elastic::search
  include ccm_elastic::snapshot
  include ccm_elastic::kibana


  # Order all the things
  anchor { 'ccm_role::perf_es::begin': } ->
  Class['ccm_elastic::search']   ->
  Class['ccm_elastic::kibana'] ->
  anchor { 'ccm_role::perf_es::end': }   
}
