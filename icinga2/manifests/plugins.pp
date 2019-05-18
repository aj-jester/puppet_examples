#
# icinga2::plugins
#
class icinga2::plugins {

  include icinga2

  $node_type = $icinga2::node_type

  package { 'nagios-plugins-all': } ->

  file { '/usr/lib64/nagios/plugins/contrib':
    ensure  => directory,
    owner   => 'icinga',
    group   => 'icinga',
    mode    => '0755',
    recurse => true,
    source  => 'puppet:///modules/icinga2/plugins',
  } ->

  archive { '/tmp/plugins_lib.tgz':
    path         => '/tmp/plugins_lib.tgz',
    source       => "http://repo.${facts['fqdn_default_location']}.ccmteam.com/repo/icinga/plugins_lib.tgz",
    extract_path => '/usr/lib64/nagios/plugins/contrib',
    creates      => '/usr/lib64/nagios/plugins/contrib/lib/README_v2.md',
    user         => 'icinga',
    group        => 'icinga',
    extract      => true,
    cleanup      => true,
  } ->

  file { '/usr/lib64/nagios/plugins/contrib/lib/README.md': ensure => absent }

  # Plugin supporting packages
  ensure_packages([
    'perl-JSON', # check_redis.pl
    'perl-Redis', # check_redis.pl
    'perl-TermReadKey', # HariSekhon Library
    'perl-Nagios-Plugin', # ccm_check_ilo2_health.pl
    'perl-XML-Simple', # ccm_check_ilo2_health.pl
    'perl-Net-SNMP', # check_snmp_environment.pl
  ])

  if str2bool($facts['is_virtual']) == false {
    ensure_packages([
      'perl-IPC-Run', # check_ipmi_sensor
    ])
  }

  if $node_type == 'satellite' {

    # NetApp cdot plugins
    ensure_packages([
      'perl-libwww-perl',
      'perl-XML-XPath',
    ])

  }

  ccm_python::pip { [
    'pymongo', # check_mongodb.py
    'python-ldap', # check_syncrepl_extended
  ]: }

}
