#
# class: ccm_mongodb::service
#
class ccm_mongodb::service {

  include ccm_mongodb

  $package_name = $ccm_mongodb::package_name

  $service_name = $package_name ? {
    'server' => 'mongod',
    'mongos' => 'mongos',
    default  => fail("${package_name} is not supported")
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }

}
