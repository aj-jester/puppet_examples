class ccm_pgsql::params {

  $package_ensure            = 'present'
  $globals_version           = '9.6'
  $service_name              = 'postgresql-9.6'
  $archive_cleanup_cmd_path  = '/usr/pgsql-9.6/bin/pg_archivecleanup'
  $archive_dir_path          = '/var/lib/pgsql/archive'
  $service_restart_on_change = false
  $config_entries            = {}
  $manage_recovery_conf      = false
  $monitoring_username       = 'icinga'
  $monitoring_password       = 'icinga'

}
