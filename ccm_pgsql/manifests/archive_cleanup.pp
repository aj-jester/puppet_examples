class ccm_pgsql::archive_cleanup (
  $cleanup_old_days = 14,
) {

  include ccm_pgsql

  $archive_dir_path         = $ccm_pgsql::archive_dir_path
  $archive_cleanup_cmd_path = $ccm_pgsql::archive_cleanup_cmd_path
  $config_entries           = $ccm_pgsql::config_entries

  $ensure = $config_entries['archive_mode']['value'] ? {
    'on'    => 'present',
    default => 'absent',
  }

  file { '/opt/ccm/bin/pgsql_archive_cleanup.sh':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_pgsql/pgsql_archive_cleanup.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  ccm_profile::cron::daily { 'pgsql_archive_cleanup':
    ensure  => $ensure,
    command => "/opt/ccm/bin/pgsql_archive_cleanup.sh -p ${archive_dir_path} -c ${archive_cleanup_cmd_path} -a ${cleanup_old_days}",
  }

}
