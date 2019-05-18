class ccm_cassandra::config {

  include ccm_cassandra

  ccm_profile::tuned { 'cassandra': }

  $config_hash    = $ccm_cassandra::config_hash
  $super_username = $ccm_cassandra::super_username
  $super_password = $ccm_cassandra::super_password

  file { '/etc/cassandra/conf/cassandra.yaml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_cassandra/cassandra.yaml.erb');
  }

  file { '/etc/cassandra/conf/cassandra-rackdc.properties':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_cassandra/cassandra-rackdc.properties.erb');
  }

  file { '/root/.cassandra':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/root/.cassandra/cqlshrc':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '1600',
    content => template('ccm_cassandra/cqlshrc.erb');
  }

}
