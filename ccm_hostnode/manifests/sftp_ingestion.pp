class ccm_hostnode::sftp_ingestion (

  $users        = undef,
  $sftp_root    = undef,

){

  include ccm_profile::firewalld

  # create/ensure sftp_users group
  group { 'sftp_chroot':
    ensure => present,
    gid    => '1390',
  } ->

  file { "/opt/sftp":
    ensure => directory,
    owner  => 'root',
    group  => 'sftp_chroot',
    mode   => '0750',
    require => Group['sftp_chroot'],
  } ->

  file { "/opt/sftp/chroots":
    ensure => directory,
    owner  => 'root',
    group  => 'sftp_chroot',
    mode   => '0750',
    require => File['/opt/sftp'],
  } 

  # create client users, home directories and RSA public keys
  create_resources('::ccm_hostnode::sftp_ingestion::create_users', $users)

  # create device to log sftpadmin in chroot
  rsyslog::snippet { "78_sftp_sftpadmin_chroot_config":
    ensure  => present,
    content => ("input(type=\"imuxsock\" Socket=\"/opt/sftp/chroots/dev/log\" CreatePath=\"on\")"),
  }

  # Clients connect on TCP/2222, so we will forward TCP/2222 to TCP/22
  firewalld_rich_rule { "Forward 2222 to 22":
    ensure           => 'present',
    zone             => 'public',
    forward_port     => {
                          'port'     => '2222',
                          'protocol' => 'tcp',
                          'to_port'  => '22',
                        },
  }

  # Setup archival script
  file { "/opt/sftp/bin":
    ensure => directory,
    owner  => 'root',
    group  => 'sftp_chroot',
    mode   => '0750',
    require => File['/opt/sftp'],
  } ->

  file { "/opt/sftp/bin/archive.sh":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('ccm_hostnode/sftp/archive.sh.erb'),
    require => File['/opt/sftp/bin'],
  } 

  # Cron entry here
  ccm_profile::cron::monthly { 'client_data_archive':
    ensure  => $ensure,
    date    => '1',
    command => '/opt/sftp/bin/archive.sh',
  }
}
 
