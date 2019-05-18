class ccm_jenkins (
  String $package_ensure = $ccm_jenkins::params::package_ensure,
) inherits ccm_jenkins::params {

  include ccm_jenkins::common

  include ccm_jenkins::build_dependencies

}
