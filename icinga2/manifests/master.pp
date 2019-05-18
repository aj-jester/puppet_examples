#
# icinga2::master
#
class icinga2::master {

  include icinga2
  include icinga2::configrr

  $master_host     = $icinga2::master_host
  $satellite_hosts = $icinga2::satellite_hosts
  $notify_service  = $icinga2::notify_service
  $api_creds       = $icinga2::api_creds
  $cmd_creds       = $icinga2::cmd_creds

  File {
    owner  => 'icinga',
    group  => 'icinga',
    notify => $notify_service,
  }

  file {

    '/etc/icinga2/features-enabled/livestatus.conf':
      ensure => present,
      mode   => '0644',
      source => 'puppet:///modules/icinga2/features-enabled/livestatus.conf';

    '/etc/icinga2/features-enabled/influxdb.conf':
      ensure => present,
      mode   => '0644',
      source => 'puppet:///modules/icinga2/features-enabled/influxdb.conf';

    '/var/lib/icinga2/ca/ca.crt':
      ensure => present,
      mode   => '0640',
      source => 'puppet:///modules/icinga2/certs/ca.crt';

    '/var/lib/icinga2/ca/ca.key':
      ensure => present,
      mode   => '0640',
      source => 'puppet:///modules/icinga2/certs/ca.key';

    [
      '/var/lib/icinga2/ca',
      '/etc/icinga2/zones.d',
      '/etc/icinga2/zones.d/master',
      '/etc/icinga2/zones.d/satellite',
    ]:
      ensure => directory,
      mode   => '0750';

    '/etc/icinga2/zones.d/master/hosts.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/master_hosts.conf.erb');

    '/etc/icinga2/zones.d/master/services.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/master_services.conf.erb');

    '/etc/icinga2/zones.d/satellite/services_foreman.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/satellite_services_foreman.conf.erb');

    '/etc/icinga2/zones.d/satellite/services_consul.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/satellite_services_consul.conf.erb');

    '/etc/icinga2/zones.d/global-templates':
      ensure  => directory,
      recurse => true,
      purge   => true,
      source  => 'puppet:///modules/icinga2/global-templates';

    '/etc/icinga2/zones.d/global-templates/commands_ccm.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/commands_ccm.conf.erb');

    '/etc/icinga2/zones.d/master/api_users.conf':
      ensure  => present,
      mode    => '0640',
      content => template('icinga2/master_api_users.conf.erb');

    '/etc/icinga2/zones.d/satellite/api_users.conf':
      ensure  => present,
      mode    => '0640',
      content => template('icinga2/satellite_api_users.conf.erb');

  }

}
