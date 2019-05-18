class ccm_profile::ldap::ipa_server {

  # This module is not intended to install the IPA Server, rather
  # it's purpose is to prepare an IPA system for installation. 
  # as of 2018, the best way to install IPA is manually and this 
  # is documented in confluence. 
  # https://crosscommercemedia.jira.com/wiki/spaces/SM/pages/656146433/FreeIPA+4.5

  # install packages to support ipa
  ensure_packages (['ipa-server', 
             'bind-dyndb-ldap',
             'ipa-server-dns',
             'python-urllib3',
             'openldap-devel',
             'gcc'],
    {'ensure'  => 'present'}
  )

  # Python module for consistancy checking
  ccm_python::pip { 'checkipaconsistency':
    ensure => '2.7.4',
  } ->

  file { '/usr/lib64/nagios/plugins/contrib/check_cipa':
    ensure => 'link',
    target => '/bin/cipa',
    require => Class['icinga2'],
  }

  include icinga2::external_monitor

}
