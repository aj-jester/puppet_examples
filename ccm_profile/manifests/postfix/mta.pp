class ccm_profile::postfix::mta (
  $smtp_listen               = '0.0.0.0',
  $mynetworks                = '127.0.0.1/32',
  $alias_maps                = 'hash:/etc/aliases',
  $external_hostname         = $::hostname,
  $inet_interfaces           = 'all',
  $inet_protocols            = 'all',
  $sender_canonical_maps     = 'regexp:/etc/postfix/canonical',
  $recipient_canonical_maps  = 'regexp:/etc/postfix/canonical',
  $external_domain           = 'localdomain',
  $relay_domains             = 'localdomain',
  $smtpd_milters             = 'inet:127.0.0.1:8891',
  $non_smtpd_milters         = '$smtpd_milters',
  $milter_default_action     = 'accept',
  $milter_protocol           = '2',
  $opendkim_socket           = 'inet:8891@127.0.0.1',
  $opendkim_trusted_hosts    = ['::1','127.0.0.1','localhost'],
  $opendkim_keys             = [{domain => 'localhost.localdomain', selector => 'default', publickey => 'p=', privatekey => '', signingdomains => ['*@localhost.localdomain'], } ],
  $opendkim_canonicalization = 'relaxed/relaxed',
  $relayhost                 = 'direct',
  $mydestination             = 'blank',
  $blackhole_domain          = 'mudpuppymedia.net',
){

  class { 'postfix':
    smtp_listen                  => $smtp_listen,
    mta                          => false,
    relayhost                    => $relayhost,
    mynetworks                   => $mynetworks,
    myorigin                     => "${external_hostname}.collectivei.com",
    alias_maps                   => $alias_maps,
    inet_interfaces              => $inet_interfaces,
    inet_protocols               => $inet_protocols,
  }

  # Code from postfix::mta; we want this, just not the blank transport maps
  # If direct is specified then relayhost should be blank
  if ($relayhost == 'direct') {
    postfix::config { 'relayhost': ensure => 'blank' }
  }
  else {
    postfix::config { 'relayhost': value => $relayhost }
  }

  if ($mydestination == 'blank') {
    postfix::config { 'mydestination': ensure => 'blank' }
  } else {
    postfix::config { 'mydestination': value => $mydestination }
  }

  postfix::config {
    'mynetworks':          value => $mynetworks;
    'virtual_alias_maps':  value => 'hash:/etc/postfix/virtual';
    'transport_maps':      value => 'hash:/etc/postfix/transport';
    'header_checks':       value => 'regexp:/etc/postfix/header_checks';
  }

  postfix::hash { '/etc/postfix/virtual':
    ensure => 'present',
  }

  postfix::map { 'transport':
    ensure => present,
    content => "${blackhole_domain} discard:silent",
    type   => 'hash',
  }

  file { '/etc/postfix/header_checks':
    ensure => 'present',
    content => template('ccm_profile/postfix/header_checks.erb'),
  }

  file { '/etc/postfix/canonical':
    ensure => 'present',
    content => '/(.*)@.*ccmteam.com/ ${1}@collectivei.com',
  }

  postfix::config { 'internal_mail_filter_classes':
    ensure => 'present',
    value  => 'bounce',
  }
  postfix::config { 'smtp_use_tls':
    ensure => 'present',
    value  => 'yes',
  }
  postfix::config { 'sender_canonical_maps':
    ensure => present,
    value  => $sender_canonical_maps,
  }
  postfix::config { 'recipient_canonical_maps':
    ensure => present,
    value  => $recipient_canonical_maps,
  }
  postfix::config { 'myhostname':
    ensure => present,
    value  => "${::hostname}.${external_domain}",
  }
  postfix::config { 'relay_domains':
    ensure => present,
    value  => $relay_domains,
  }
  postfix::config { 'smtpd_milters':
    ensure => present,
    value  => $smtpd_milters,
  }
  postfix::config { 'non_smtpd_milters':
    ensure => present,
    value  => $non_smtpd_milters,
  }
  postfix::config { 'milter_default_action':
    ensure => present,
    value  => $milter_default_action,
  }
  postfix::config { 'milter_protocol':
    ensure => present,
    value  => $milter_protocol,
  }

  class { '::opendkim':
    socket           => $opendkim_socket,
    trusted_hosts    => $opendkim_trusted_hosts,
    keys             => $opendkim_keys,
    canonicalization => $opendkim_canonicalization,
  }

}
