#
# icinga2::config
#
class icinga2::config {

  include icinga2

  $master_host     = $icinga2::master_host
  $satellite_hosts = $icinga2::satellite_hosts
  $node_type       = $icinga2::node_type
  $ticket_salt     = $icinga2::ticket_salt
  $sudoers         = $icinga2::sudoers

  File {
    owner => 'icinga',
    group => 'icinga',
  }

  file {
    '/etc/icinga2/icinga2.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/icinga2.conf.erb');

    '/etc/icinga2/constants.conf':
      ensure  => present,
      mode    => '0640',
      content => template('icinga2/constants.conf.erb');

    '/etc/icinga2/zones.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/zones.conf.erb');

    '/etc/icinga2/features-enabled':
      ensure  => directory,
      mode    => '0750',
      recurse => true,
      purge   => true;

    '/etc/icinga2/features-enabled/api.conf':
      ensure  => present,
      mode    => '0644',
      content => template('icinga2/api.conf.erb');

    '/etc/sudoers.d/icinga-cmds':
      ensure  => present,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('icinga2/icinga2-cmds.sudoers.erb');

    '/etc/icinga2/features-enabled/mainlog.conf':
      ensure => present,
      mode   => '0644',
      source => 'puppet:///modules/icinga2/features-enabled/mainlog.conf';

    '/var/lib/icinga2/certs':
      ensure  => directory,
      mode    => '0750';

    '/var/lib/icinga2/certs/ca.crt':
      ensure => present,
      mode   => '0644',
      source => "puppet:///modules/icinga2/certs/ca.crt";
  }

  if $node_type == 'master' {
    include icinga2::master
    include icinga2::notifications

    $files_to_delete = []

  } elsif $node_type == 'satellite' {
    include icinga2::notifications
    include icinga2::node_registrator

    $files_to_delete = []

  } elsif $node_type == 'client' {
    include icinga2::node_registrator

    $files_to_delete = ['/etc/icinga2/scripts']

  } else {
    fail("Unknown node type ${node_type}.")
  }

  $default_files_to_delete = [
    '/etc/icinga2/pki',
    '/etc/icinga2/conf.d',
    '/etc/icinga2/repository.d',
    '/etc/icinga2/zones.conf.rpmnew',
    '/etc/icinga2/icinga2.conf.rpmnew',
    '/etc/icinga2/init.conf.rpmsave',
  ]

  $all_files_to_delete = unique(flatten([$default_files_to_delete, $files_to_delete]))

  file { $all_files_to_delete:
    ensure => absent,
    force  => true;
  }

}
