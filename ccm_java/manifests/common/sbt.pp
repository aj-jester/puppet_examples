class ccm_java::common::sbt (
  $extract_path    = '/opt/sbt',
  $default_version = '1.2.1',
){

  file { $extract_path:
    ensure => directory,
    mode   => '0755',
  } ->

  file { '/opt/ccm/bin/set_default_sbt.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_java/sbt/set_default_sbt.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  exec { 'set_default_sbt':
    command => '/opt/ccm/bin/set_default_sbt.sh',
    unless  => "/usr/sbin/alternatives --display sbt | grep 'link currently points to /opt/sbt/sbt-${default_version}/bin/sbt'",
  }

}
