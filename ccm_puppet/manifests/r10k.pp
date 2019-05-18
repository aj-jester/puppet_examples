#
# ccm_puppet::r10k
#
class ccm_puppet::r10k (
  $slack_webhook       = undef,
  $proxy_url           = "http://proxy.${facts[app_env]}.${facts[fqdn_location]}.ccmteam.com:3128",
  $git_ssh_private_key = undef,
) {

  Ccm_ruby::Rh_rubygems {
    ruby_version => 'ruby24',
  }

  ensure_packages(['gcc-c++', 'cmake', 'libgit2', 'libssh2', 'libssh2-devel',],
  { 'before' => Ccm_ruby::Rh_rubygems['r10k', 'rugged'] })

  # Currently the latest version of puppet_forge gem requires semantic_puppet 1.0
  # whereas r10k requires 0.1.0. So we have to pin the puppet_forge version to 2.2.6
  # until r10k updates its dependencies
  ccm_ruby::rh_rubygems { 'puppet_forge': ensure => '2.2.6' } ->

  ccm_ruby::rh_rubygems {
      'r10k':
        ensure => '2.5.5';
      'rugged':
        ensure => '0.26.0';
  }

  file {
    '/etc/puppetlabs/r10k':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
    '/etc/puppetlabs/r10k/r10k.yaml':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('ccm_puppet/r10k.yaml.erb');
    '/root/.ssh':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0600';
    '/root/.ssh/ccm_r10k':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => $git_ssh_private_key;
  }

  file { '/usr/local/bin/r10k_deploy.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_puppet/r10k_deploy.sh.erb'),
  }

  ansible::playbook { 'r10k': }

}
