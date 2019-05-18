class ccm_mysql::cluster::uni {

  include ccm_mysql

  Class['ccm_mysql'] ->

  file { '/vol1/tmp/mysql':
    ensure => directory,
    owner  => 'mysql',
    group  => 'mysql',
    mode   => '0755',
    before => Service['mysqld'],
  } ->

  class { '::mysql::server':
    package_manage   => false,
    root_password    => $ccm_mysql::root_password,
    override_options => $ccm_mysql::override_options,
  }

}
