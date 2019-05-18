class ccm_profile::ruby {

  # System Wide Ruby
  package {
    'rh-ruby24':
      ensure  => "2.4-2.el${::operatingsystemmajrelease}",
      require => Class['ccm_repo::sclo'];
  } ->

  file { '/etc/profile.d/enable-ruby.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/ccm_profile/profile.d/enable-ruby.sh',
  }

}
