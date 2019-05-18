class ccm_java::common::openjdk (
  $extract_path    = '/opt/java',
  $default_version = '10.0.2',
){

  file { $extract_path:
    ensure => directory,
    mode   => '0755',
  } ->

  file { '/opt/ccm/bin/set_default_java.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('ccm_java/openjdk/set_default_java.sh.erb'),
    require => File['/opt/ccm/bin'],
  } ->

  file { '/etc/profile.d/java.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_java/openjdk/profile.d_java.sh.erb'),
  } ->

  exec { 'set_default_java':
    command => '/opt/ccm/bin/set_default_java.sh',
    unless  => "/usr/sbin/alternatives --display java | grep 'link currently points to /opt/java/jdk-${default_version}/bin/java'",
  }

}
