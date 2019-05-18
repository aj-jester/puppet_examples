class ccm_profile::ssh::banner (
  String $type     = 'internal',
) {

  file { '/etc/ssh/banner':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_profile/ssh/banner.erb'),
  }

}
