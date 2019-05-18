class ccm_artifactory (
  String $ensure                  = $ccm_artifactory::params::ensure,
  Stdlib::Absolutepath $filestore = $ccm_artifactory::params::filestore,
) inherits ccm_artifactory::params {

  anchor { 'ccm_artifactory::begin': } ->
  class { 'ccm_artifactory::install': notify => Class['ccm_artifactory::service'] } ->
  class { 'ccm_artifactory::config': notify => Class['ccm_artifactory::service'] } ->
  class { 'ccm_artifactory::service': } ->
  anchor { 'ccm_artifactory::end': }

}
