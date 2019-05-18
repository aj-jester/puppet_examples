class ccm_pgsql (
  # $postgres_password, Only enable on the first run
  String $package_ensure             = $ccm_pgsql::params::package_ensure,
  String $globals_version            = $ccm_pgsql::params::globals_version,
  String $service_name               = $ccm_pgsql::params::service_name,
  Boolean $manage_recovery_conf      = $ccm_pgsql::params::manage_recovery_conf,
  Boolean $service_restart_on_change = $ccm_pgsql::params::service_restart_on_change,
  Hash[String, Any] $config_entries  = $ccm_pgsql::params::config_entries,
  String $monitoring_username        = $ccm_pgsql::params::monitoring_username,
  String $monitoring_password        = $ccm_pgsql::params::monitoring_password,
  String $archive_cleanup_cmd_path   = $ccm_pgsql::params::archive_cleanup_cmd_path,
  String $archive_dir_path           = $ccm_pgsql::params::archive_dir_path,
) inherits ccm_pgsql::params {

  include ccm_repo::postgresql
  include ccm_pgsql::backup
  include ccm_pgsql::archive_cleanup

  ccm_profile::base::vol_dirs { '1': }

  class { 'postgresql::globals':
    version              => $globals_version,
    service_name         => $service_name,
    manage_recovery_conf => $manage_recovery_conf,
    datadir              => '/vol1/var/lib/pgsql/data',
  }

  class { 'postgresql::server':
    # postgres_password          => $postgres_password, Only enable on the first run
    package_ensure             => $package_ensure,
    service_restart_on_change  => $service_restart_on_change,
    ip_mask_deny_postgres_user => '127.0.0.1/32',
    ip_mask_allow_all_users    => '10.0.0.0/8',
    listen_addresses           => $::ccm_ipaddress,
  }

  class { 'postgresql::server::contrib': }

  file { '/vol1/var/lib/pgsql':
    ensure => directory,
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0755',
  }

  create_resources('postgresql::server::config_entry', $config_entries, {})

  # Icinga monitoring creds
  file { '/var/spool/icinga2/.pgpass':
    ensure  => present,
    owner   => 'icinga',
    group   => 'icinga',
    mode    => '0600',
    content => "${::fqdn}:5432:*:${monitoring_username}:${monitoring_password}",
  }

}
