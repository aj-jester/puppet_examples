class ccm_puppet::gem_proxy (
  Enum['absent', 'present'] $ensure = 'present'
  ){
  # We don't know if this directory and file are managed elsewhere
  file {
    default:
      owner => 'puppet',
      group => 'puppet';

    '/opt/puppetlabs/puppet/etc':
      ensure => directory;

    '/opt/puppetlabs/puppet/etc/gemrc':
      ensure  => $ensure,
      content => "---\nhttp-proxy: http://proxy.${facts[app_env]}.${facts[fqdn_location]}.ccmteam.com:3128\n"
  }
}
