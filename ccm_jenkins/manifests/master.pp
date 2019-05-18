#
# class: ccm_jenkins::master
#
class ccm_jenkins::master (
  $backup_ensure   = 'absent',
) {

  include ccm_jenkins
  include ccm_jenkins::ssh_keys
  include ccm_repo::jenkins
  include ccm_nginx::service::jenkins

  Class['ccm_jenkins'] ->

  package { 'jenkins':
    ensure => $ccm_jenkins::package_ensure,
    notify => Service['jenkins'],
  } ->

  file { '/var/lib/jenkins/.ssh/jenkins_cluster':
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600',
    content => $ccm_jenkins::ssh_keys::private['jenkins_cluster'],
  } ->

  file { '/etc/sysconfig/jenkins':
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600',
    content => template('ccm_jenkins/sysconfig.erb'),
  } ~>

  service { 'jenkins':
    ensure => running,
    enable => true,
  }

  class { 'ccm_profile::lvm_backup':
    ensure                 => $backup_ensure,
    data_vol               => 'varlv',
    snapshot_relative_path => 'lib/jenkins',
    snapshot_delta_gb      => 5,
    cron_hour              => 5,
    cleanup_old_days       => 14,
  }

}
