class ccm_puppet::hiera (
  Optional[String] $consul_token = undef,
) {

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_puppet/hiera.yaml.erb'),
    notify  => Class['puppet::server::service'],
  }

}
