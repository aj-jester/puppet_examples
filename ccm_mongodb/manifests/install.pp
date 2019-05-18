#
# class: ccm_mongodb::install
#
class ccm_mongodb::install {

  include ccm_mongodb
  include ccm_repo::mongodb
  include ccm_mongodb::client
  include ccm_mongodb::backup

  $package_name   = $ccm_mongodb::package_name
  $package_ensure = $ccm_mongodb::package_ensure
  $notify_service = $ccm_mongodb::notify_service

  Class['ccm_repo::mongodb'] ->

  package {
    "mongodb-org-${package_name}":
      ensure => $package_ensure,
      notify => $notify_service;
    'numactl':
      notify => $notify_service;
  }

}
