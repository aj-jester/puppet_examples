class ccm_java::common::maven (
  $extract_path    = '/opt/maven',
  $default_version = '3.5.4',
){

  file { $extract_path:
    ensure => directory,
    mode   => '0755',
  } ->

  file { '/opt/ccm/bin/set_default_maven.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_java/maven/set_default_maven.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  exec { 'set_default_maven':
    command => '/opt/ccm/bin/set_default_maven.sh',
    unless  => "/usr/sbin/alternatives --display mvn | grep 'link currently points to /opt/maven/apache-maven-${default_version}/bin/mvn'",
  }

}
