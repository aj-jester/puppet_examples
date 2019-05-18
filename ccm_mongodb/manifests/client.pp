#
# class: ccm_mongodb::client
#
class ccm_mongodb::client {

  include ccm_mongodb
  include ccm_repo::mongodb

  $package_ensure = $ccm_mongodb::package_ensure

  package {
    [
      'mongodb-org-tools',
      'mongodb-org-shell',
    ]:
      ensure  => $package_ensure,
      require => Class['ccm_repo::mongodb'],
  }

}
