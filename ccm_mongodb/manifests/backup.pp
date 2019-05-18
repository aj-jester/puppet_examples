class ccm_mongodb::backup (
  $ensure                 = 'absent',
  $remote_mount_type      = 'local',
  $remote_volume          = undef,
  $remote_mount_dir       = '/mnt/mongodb_backups',
  $mongodb_port           = 27017,
  $mongodb_authdb         = 'admin',
  $vault_api_uri          = "https://vault.${::fqdn_location}.ccmteam.com:8200/v1",
  $vault_username         = undef,
  $vault_password         = undef,
  $vault_key_path         = 'boot/luks-key',
  $volume_group_path      = '/dev/vg1',
  $data_vol               = 'vol1lv',
  $snapshot_relative_path = 'var/lib/mongo',
  $snapshot_delta_gb      = 1,
  $pigz_processor_count   = $facts['processors']['physicalcount'],
  $cleanup_old_days       = 14,
  $gpg_key_id             = undef,
  $cron_hour              = fqdn_rand(24, 'mongodb_backup_daily_hour'),
) {

  include ccm_mongodb

  $mongodb_username = $ccm_mongodb::admin_username
  $mongodb_password = $ccm_mongodb::admin_password

  case $remote_mount_type {
    'glusterfs': {
      class { 'ccm_profile::gluster::client': }
    }
    'nfs': {
      class { 'ccm_profile::nfs::client': }
    }
    default: { }
  }

  ccm_profile::gpg { $gpg_key_id: ensure => $ensure }

  file { '/opt/ccm/bin/mongodb_backup.sh':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_mongodb/mongodb_backup.sh.erb'),
    require => File['/opt/ccm/bin'],
  }

  ccm_profile::cron::daily { 'mongodb_backup':
    ensure  => $ensure,
    hour    => $cron_hour,
    command => '/opt/ccm/bin/mongodb_backup.sh',
  }

}
