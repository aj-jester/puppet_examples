class ccm_profile::base::dirs {

  file { [
      '/opt/ccm',
      '/opt/ccm/bin',
      '/opt/ccm/data',
    ]:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
  }

}
