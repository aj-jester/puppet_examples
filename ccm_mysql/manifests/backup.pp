class ccm_mysql::backup (
  $ensure               = 'absent',
  $remote_mount_type    = 'local',
  $remote_volume        = undef,
  $remote_mount         = '/mnt/infra_backups',
  $username             = undef,
  $password             = undef,
  $pigz_processor_count = 1,
  $cleanup_old_days     = 7,
  $gpg_key_id           = undef,
) {

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

  file { '/opt/ccm/bin/mysql_backup.sh':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_mysql/mysql_backup.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  ccm_profile::cron::daily { 'mysql_backup':
    ensure  => $ensure,
    command => '/opt/ccm/bin/mysql_backup.sh',
  }

}
