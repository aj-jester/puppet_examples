class ccm_elastic::curator (

){
  # Pull in the common ES dependencies
  include ccm_elastic::common

  package { 'elasticsearch-curator':
    ensure  => installed,
    require => Class['ccm_elastic::common'],
  }

}
