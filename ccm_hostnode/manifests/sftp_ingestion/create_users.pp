define ccm_hostnode::sftp_ingestion::create_users (

  $user_uid       = undef,
  $user_gid       = undef,
  $key            = undef,
  $key_type       = undef,
  $home_directory = undef,
  $admin_account  = false,

  ){

  user { "${title}":
    ensure   => present,
    name     => "${title}",
    shell    => '/bin/false',
    uid      => $user_uid,
    gid      => $user_gid,
    home     => $home_directory,
  } 

  if $admin_account == false {
    file { "/${home_directory}/inbound":
      ensure => directory,
      owner  => "${title}",
      group  => $user_gid,
      mode   => '0760',
    } 

    file { "/${home_directory}/outbound":
      ensure => directory,
      owner  => "${title}",
      group  => $user_gid,
      mode   => '0760',
    }

    file { "/${home_directory}":
      ensure => directory,
      owner  => 'root',
      group  => $user_gid,
      mode   => '0750',
      require => User["${title}"],
    } 

    # add /dev/log to each client's chroot. This allows us full logging
    rsyslog::snippet { "78_sftp_${title}_chroot_config":
      ensure  => present,
      content => ("input(type=\"imuxsock\" Socket=\"/opt/sftp/chroots/${title}/dev/log\" CreatePath=\"on\")"),
    }
  } 

  file { "/${home_directory}/.ssh":
    ensure => directory,
    owner  => $title,
    group  => $user_gid,
    mode   => '0700',
  } 

  ssh_authorized_key { "${title}":
    ensure => present,
    user   => "${title}",
    type   => $key_type,
    key    => $key,
  }

}
