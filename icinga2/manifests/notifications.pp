#
# icinga2::notifications
#
class icinga2::notifications {

  include icinga2

  $node_type      = $icinga2::node_type
  $notify_service = $icinga2::notify_service

  File {
    owner => 'icinga',
    group => 'icinga',
    notify => $notify_service,
  }

  file {
    '/etc/icinga2/features-enabled/notification.conf':
      ensure => present,
      mode   => '0644',
      source => 'puppet:///modules/icinga2/features-enabled/notification.conf';

    '/etc/icinga2/scripts':
      ensure  => directory,
      recurse => true,
      purge   => true,
      source  => 'puppet:///modules/icinga2/scripts';

    '/etc/icinga2/scripts/victorops-notification.rb':
      ensure  => present,
      mode    => '0755',
      content => template('icinga2/victorops-notification.rb.erb');

    '/etc/icinga2/features-enabled/checker.conf':
      ensure => present,
      mode   => '0644',
      source => 'puppet:///modules/icinga2/features-enabled/checker.conf';

    '/etc/icinga2/notifications.conf':
      ensure  => present,
      mode    => '0644',
      content => template("icinga2/${node_type}_notifications.conf.erb");
  }

}
