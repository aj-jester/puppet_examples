class ccm_puppet::foreman::backup (
  $remote_mount         = '/mnt/backups',
  $remote_mount_type    = 'local',
  $remote_volume        = undef,
  $cleanup_old_days     = 14,
  $pigz_processor_count = 1,
  $gpg_key_id           = undef,
){

  case $remote_mount_type {
    'glusterfs': { include ccm_profile::gluster::client }
    'nfs': { include ccm_profile::nfs::client }
    default: { }
  }

  ccm_profile::gpg { $gpg_key_id: }

  file { '/opt/ccm/bin/foreman_backup.sh':
    ensure  => present,
    owner   => 'foreman',
    group   => 'foreman',
    mode    => '0750',
    content => template('ccm_puppet/foreman_backup.sh.erb'),
    require => File['/opt/ccm/bin'],
  }

  ccm_profile::cron::daily { 'foreman_backup':
    command => '/opt/ccm/bin/foreman_backup.sh',
    user    => 'root',
  }

}
