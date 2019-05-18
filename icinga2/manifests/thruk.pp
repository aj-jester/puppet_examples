#
# icinga2::thruk
#
class icinga2::thruk (
  $ensure = '2.22-1',
) {

  package {
    'thruk':
      ensure => $ensure,
      notify => Service['httpd'];

    'mod_ldap':
      ensure => installed,
      notify => Service['httpd'];
  } ->

  file {
    '/etc/thruk/thruk_local.conf':
      ensure  => present,
      owner   => 'apache',
      group   => 'apache',
      mode    => '0660',
      content => template('icinga2/thruk_local.conf.erb');
    '/etc/thruk/cgi.cfg':
      ensure  => present,
      owner   => 'apache',
      group   => 'apache',
      mode    => '0644',
      content => template('icinga2/thruk_cgi.cfg.erb');
    '/etc/httpd/conf.d/thruk.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('icinga2/thruk.conf.httpd.erb');
  } ~>

  service { 'httpd':
    ensure => running,
    enable => true,
  }

}
