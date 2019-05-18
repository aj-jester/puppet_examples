class ccm_consul::backup (
  $remote_mount         = '/opt/consul/backups',
  $token                = undef,
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

  file { '/opt/ccm/bin/consul_backup.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template('ccm_consul/consul_backup.sh.erb'),
    require => File['/opt/ccm/bin'],
  }

  file { $remote_mount:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  ccm_profile::cron::daily { 'consul_backup':
    command => '/opt/ccm/bin/consul_backup.sh',
  }

}
