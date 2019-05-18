class ccm_profile::ldap::ipa_client (

  $principal = 'admin',
  $password  = 'default',

){

  # Which IPA Servers to point at based on the client location 
  $ipa_server = $facts['fqdn_location'] ? {
    'iad1'  => [ 'ipa-server-1.ops.iad1.ccmteam.com', 'ipa-server-2.ops.iad1.ccmteam.com' ],
    'slc1'  => [ 'ipa-server-1.ops.slc1.ccmteam.com', 'ipa-server-2.ops.iad1.ccmteam.com' ],
    'vbox'  => [ 'ipa-server-1.stg.vbox.ccmteam.com' ],
    default => [ 'ipa-server-1.ops.iad1.ccmteam.com', 'ipa-server-2.ops.iad1.ccmteam.com' ],
  }

  class { 'ipaclient':
    hostname           => $::fqdn,
    principal          => $principal,
    password           => $password,
    server             => $ipa_server,
    domain             => 'ccmteam.com',
    realm              => 'CCMTEAM.COM',
    ntp                => false,
    force_join         => true,
  }

  # We need to ensure oddjobd is running as it ensures home directory creation
  service { 'oddjobd':
    ensure => running,
    enable => true,
  }

  # Install script to correct user permissions post IPA switchover
  file { '/opt/ccm/bin/fix_ipa_homedir.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    source  => 'puppet:///modules/ccm_profile/ldap/fix_ipa_homedir.sh',
    require => File['/opt/ccm/bin'],
  } ->

  # This is a temporary exec. It should only run one time when the script is dropped.
  # It will run once fixing any permissions in/for /home/$user
  # It can be removed once all puppet 5 hosts have migrated to IPA
  exec {'run /opt/ccm/bin/fix_ipa_homedir.sh via at in 5 minutes':
    command     => '/opt/ccm/bin/fix_ipa_homedir.sh',
    subscribe   => File['/opt/ccm/bin/fix_ipa_homedir.sh'],
    refreshonly => true,
  }

}

