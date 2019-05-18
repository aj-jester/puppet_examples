class ccm_consul::vault (

    $user                = 'vault',
    $group               = 'vault',
    $bin_dir             = '/opt/vault/bin',
    $config_dir          = '/etc/vault/',
    $purge_config_dir    = true,
    $install_method      = 'archive',
    $download_url_base   = 'http://repo.iad1.ccmteam.com/repo/hashicorp/vault/',
    $version             = '0.9.6',
    $manage_service_file = true,
    $backend             = undef,
    $listener            = undef,
    $logstash_slack      = false,
){
  # Let's get the ccmteam cert for vault goodness.
  include ccm_certs::wildcard_ccmteam_com

  # Allow a logstash instance to trigger slack alerts
  if $logstash_slack {
    include ccm_elastic::logstash
  }

  file { '/etc/vault/ssl':
    ensure  => 'directory',
    owner   => 'vault',
    group   => 'vault',
    mode    => '0640',
    require => File['/opt/vault'],
  }

  file { [ 
    '/opt/vault',
    '/opt/vault/bin',
    ]:
      ensure => 'directory',
      owner  => 'vault',
      group  => 'vault',
  }

  # Puppet Certs are added primarly for working in vagrant. In prod
  # we leverage the ccmteam certificate for the service.

  file { '/etc/vault/ssl/vault.crt':
    ensure => 'present',
    owner  => 'vault',
    group  => 'vault',
    mode   => '0640',
    source => "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
  }

  file { '/etc/vault/ssl/vault.key':
    ensure => 'present',
    owner  => 'vault',
    group  => 'vault',
    mode   => '0640',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
  }

  class { '::vault':
    user                => $::ccm_consul::vault::user,
    group               => $::ccm_consul::vault::group,
    bin_dir             => $::ccm_consul::vault::bin_dir,
    config_dir          => $::ccm_consul::vault::config_dir,
    purge_config_dir    => $::ccm_consul::vault::purge_config_dir,
    install_method      => $::ccm_consul::vault::install_method,
    download_url_base   => $::ccm_consul::vault::download_url_base,
    version             => $::ccm_consul::vault::version,
    manage_service_file => $::ccm_consul::vault::manage_service_file,
    backend             => $::ccm_consul::vault::backend,
    listener            => $::ccm_consul::vault::listener,
  }
}


