class ccm_java::common::scala (
  $extract_path    = '/opt/scala',
  $default_version = '2.11.2',
){

  file { $extract_path:
    ensure => directory,
    mode   => '0755',
  } ->

  file { '/opt/ccm/bin/set_default_scala.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_java/scala/set_default_scala.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  exec { 'set_default_scala':
    command => '/opt/ccm/bin/set_default_scala.sh',
    unless  => "/usr/sbin/alternatives --display scala | grep 'link currently points to /opt/scala/scala-${default_version}/bin/scala'",
  }

}
