class ccm_cassandra::install {

  include ccm_java::eight
  include ccm_repo::cassandra

  include ccm_cassandra

  $package_ensure = $ccm_cassandra::package_ensure

  ccm_profile::base::vol_dirs { '1': } ->

  Class['ccm_java::eight', 'ccm_repo::cassandra'] ->

  package { ['cassandra', 'cassandra-tools']:
    ensure  => $package_ensure,
  } ->

  file { '/vol1/var/lib/cassandra':
    ensure => directory,
    owner  => 'cassandra',
    group  => 'cassandra',
    mode   => '0755',
  }

}
