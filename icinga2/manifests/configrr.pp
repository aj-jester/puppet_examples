#
# icinga2::service
#
class icinga2::configrr (
  $foreman_host     = 'foreman.ccmteam.com',
  $foreman_username = 'admin',
  $foreman_password = undef,
  $consul_token     = undef,
) {

  # At the moment its not sure how we want to install Configrr.
  # For now lets just drop the configuration.
  file {
    '/etc/configrr':
      ensure  => directory,
      mode    => '0755';

    '/etc/configrr/config.yml':
      ensure  => present,
      owner   => 'icinga',
      group   => 'icinga',
      mode    => '0640',
      content => template('icinga2/configrr.config.yml.erb');

    '/etc/configrr/agentless_hosts.yml':
      ensure  => present,
      owner   => 'icinga',
      group   => 'icinga',
      mode    => '0644',
      content => template('icinga2/configrr.agentless_hosts.yml.erb');

    '/opt/configrr':
      ensure  => directory,
      recurse => true,
      purge   => true,
      source  => "puppet:///modules/icinga2/configrr/${::fqdn_location}";
  }

  ccm_profile::cron::hourly { 'configrr':
    command => '/usr/bin/scl enable rh-ruby24 -- ruby /opt/rh/rh-ruby24/root/usr/local/bin/configrr generate',
  }

}
