class ccm_consul::facter_to_consul (
  $facts_data_file   = '/opt/ccm/data/facter_to_consul.json',
  $consul_url        = 'http://localhost:8500',
  $consul_token      = undef,
  $consul_schemas    = ['facter', 'hiera'],
  $consul_factsd_dir = '/opt/puppetlabs/facter/facts.d',
) {

  file { $facts_data_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_consul/facter_to_consul.json.erb'),
    require => File['/opt/ccm/data'],
    notify  => Exec['facter_to_consul'],
  } ->

  file { $consul_factsd_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  } ->

  Class['ccm_ruby'] ->

  file { '/opt/ccm/bin/facter_to_consul.rb':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_consul/facter_to_consul.rb.erb'),
    require => File['/opt/ccm/bin'],
    notify  => Exec['facter_to_consul'],
  } ->

  ccm_profile::cron::hourly { 'facter_to_consul':
    command => '/usr/bin/scl enable rh-ruby24 -- ruby /opt/ccm/bin/facter_to_consul.rb',
  } ->

  exec { 'facter_to_consul':
    command     => '/opt/rh/rh-ruby24/root/usr/bin/ruby /opt/ccm/bin/facter_to_consul.rb',
    refreshonly => true,
  }

}
