class ccm_profile::lvm_backup (
  $ensure                 = 'absent',
  $remote_mount_type      = 'local',
  $remote_volume          = undef,
  $remote_mount_dir       = '/mnt/infra_backups',
  $volume_group_path      = '/dev/vg0',
  $data_vol               = 'rootlv',
  $snapshot_relative_path = 'home/username',
  $snapshot_delta_gb      = 1,
  $pigz_processor_count   = $facts['processors']['physicalcount'],
  $cleanup_old_days       = 7,
  $gpg_key_id             = undef,
  $cron_hour              = fqdn_rand(24, 'lvm_backup_daily_hour'),
) {

  case $remote_mount_type {
    'glusterfs': {
      class { 'ccm_profile::gluster::client':
        repo_ensure    => $ensure,
        package_ensure => $ensure,
      }
    }
    'nfs': {
      class { 'ccm_profile::nfs::client':
        ensure => $ensure,
      }
    }
    default: { }
  }

  ccm_profile::gpg { $gpg_key_id: ensure => $ensure }

  file { '/opt/ccm/bin/lvm_backup.sh':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_profile/lvm_backup.sh.erb'),
    require => File['/opt/ccm/bin'],
  }

  ccm_profile::cron::daily { 'lvm_backup':
    ensure  => $ensure,
    hour    => $cron_hour,
    command => '/opt/ccm/bin/lvm_backup.sh',
  }

}
