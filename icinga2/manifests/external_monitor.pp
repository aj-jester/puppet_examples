#
# icinga2::external_monitor
#
class icinga2::external_monitor {

  include icinga2

  $master_host     = $icinga2::master_host
  $satellite_hosts = $icinga2::satellite_hosts
  $api_creds       = $icinga2::api_creds

  file { '/opt/ccm/bin/icinga2_external_monitor.rb':
    ensure  => present,
    mode    => '0755',
    content => template('icinga2/icinga2_external_monitor.rb.erb');
  }


  ccm_profile::cron::hourly { 'icinga2_external_monitor':
    command => '/opt/ccm/bin/icinga2_external_monitor.rb',
    minute  => '*/15',
  }


}
