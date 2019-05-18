class ccm_hostnode::influx_db (
  $data_dir = '/vol1/influxdb',
) {

  include ccm_profile::ccmcmd

  ensure_packages(['influxdb'])

  ccm_profile::base::vol_dirs { '1': } ->

  file { $data_dir:
    ensure  => directory,
    owner   => 'influxdb',
    group   => 'influxdb',
    mode    => '0755',
    require => Package['influxdb'],
  } ->

  file { '/etc/influxdb/influxdb.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_hostnode/influx_db/influxdb.conf.erb'),
  } ~>

  service { 'influxdb':
    ensure => running,
    enable => true,
  }

}
