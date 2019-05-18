class ccm_profile::ldap::centos {

  # proxy is only set if running in the data center
  # Which LDAP Server to point at 
  $ldap_server = $facts['ccm_dc'] ? {
    'iad1'  => "openldap01.ops.iad1.ccmteam.com",
    'slc1'  => "openldap01.ops.slc1.ccmteam.com",
    default => 'openldap01.ops.iad1.ccmteam.com'
  }

  file { '/etc/openldap/ldap.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_profile/ldap/ldap.erb'),
  } ->

  file { '/etc/openldap/certs/puppet3_ca-bundle.crt':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ccm_profile/pki/puppet3_ca-bundle.crt',
  } ->

  class {'::sssd':
    config => {
      'sssd' => {
        'domains'             => 'ccmteam.com',
        'config_file_version' => 2,
        'services'            => ['nss', 'pam'],
      },
      'domain/ccmteam.com' => {
        'ldap_server'                   => ["${ldap_server}"],
        'cache_credentials'             => true,
        'id_provider'                   => 'ldap',
        'auth_provider'                 => 'ldap',
        'ldap_uri'                      => "ldap://${ldap_server}",
        'ldap_search_base'              => 'dc=ccmteam, dc=com',
        'ldap_id_start_tls'             => true,
        'ldap_tls_reqcert'              => 'demand',
      },
    }
  }
}
