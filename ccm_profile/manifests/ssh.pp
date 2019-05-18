class ccm_profile::ssh (

  $sftp_chroot = false,

){

  package { [
    'openssh',
    'openssh-clients',
    'openssh-server'
    ]:
    ensure => installed,
  } ->

  class { 'ccm_profile::ssh::banner': 
    notify => Service['sshd'],
  } ->

  file { '/etc/ssh/sshd_config':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('ccm_profile/ssh/sshd_config.erb'),
  } ~>

  service { 'sshd':
    ensure => running,
    enable => true,
  }

}
