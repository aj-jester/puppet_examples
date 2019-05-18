class ccm_profile::base::motd {
  file { '/etc/motd':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    content => template('ccm_profile/base/motd.sh.erb'),
  }
}
