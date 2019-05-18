## The define below is used to populate the configurations of the various "data center" backups.
define ccm_kvm::vm_backup (
  $ovirt_engine       = $::ccm_kvm::engine::ovirt_engine_api_host,
  $cluster            = undef,
  $storage            = undef,
  $vms                = undef,
  $export_domain      = undef,
  $username           = $::ccm_kvm::engine::ovirt_backup_user,
  $password           = $::ccm_kvm::engine::ovirt_backup_pass,
  $backup_keep_count  = '3',
  $dry_run            = 'false',
  $vm_name_max_length = '63',
  ){

  file { "/etc/oVirtBackup/${title}.cfg":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('ccm_kvm/oVirtBackup.cfg.erb'),
  }

   ccm_profile::cron::daily { "oVirt_backup_${title}":
    command => "/etc/oVirtBackup/backup.py -c /etc/oVirtBackup/${title}.cfg",
  }
}
