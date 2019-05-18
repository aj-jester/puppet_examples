class ccm_profile::ccmcmd (
  $config = {},
) {

  ccm_python::pip {
    [
      'pyyaml',
      'texttable',
    ]:
  } ->

  ccm_python::pip { 'ccmcmd':
    ensure => 'present',
    url    => "http://repo.${::fqdn_location}.ccmteam.com/repo/pip-packages/ccmcmd-0.1.0.tar.gz",
    proxy  => false,
  } ->

  file { '/opt/ccm/data/ccmcmd.yaml':
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    content => template('ccm_profile/ccmcmd.yaml.erb'),
    require => File['/opt/ccm/data'],
  }

}
