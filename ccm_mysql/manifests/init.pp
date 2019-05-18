class ccm_mysql (
  String $package_ensure = $ccm_mysql::params::package_ensure,
  String $root_password  = $ccm_mysql::params::root_password,
  Hash $override_options = $ccm_mysql::params::override_options,
) inherits ccm_mysql::params {

  include ccm_repo::mariadb
  include ccm_mysql::backup

  ccm_profile::base::vol_dirs { '1': }

  package { 'mysql-server':
    ensure  => $package_ensure,
    name    => 'MariaDB-server',
    require => Class['ccm_repo::mariadb'],
  } ->

  file { [
      '/vol1/var/lib/mysql',
      '/var/run/mariadb',
    ]:
    ensure => directory,
    owner  => 'mysql',
    group  => 'mysql',
    mode   => '0755',
  }

}
