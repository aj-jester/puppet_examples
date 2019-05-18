#
# class: ccm_jenkins::common
#
class ccm_jenkins::common {

  include ccm_jenkins
  include ccm_jenkins::ssh_keys

  group { 'jenkins':
    ensure => present,
    gid    => '1001',
  } ->

  user { 'jenkins':
    ensure         => present,
    uid            => '1001',
    gid            => '1001',
    home           => '/var/lib/jenkins',
    shell          => '/bin/bash',
    purge_ssh_keys => true,
    managehome     => true,
  } ->

  file { '/var/lib/jenkins/.ssh':
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0700',
  } ->

  ssh_authorized_key { 'jenkins_cluster':
    ensure => present,
    name   => 'jenkins_cluster',
    user   => 'jenkins',
    type   => 'ssh-rsa',
    key    => $ccm_jenkins::ssh_keys::public['jenkins_cluster'],
  } ->

  file { '/var/lib/jenkins/.ssh/publish_over_ssh':
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600',
    content => $ccm_jenkins::ssh_keys::private['publish_over_ssh'],
  } ->

  file { '/var/lib/jenkins/.ssh/config':
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600',
    content => template('ccm_jenkins/config.erb'),
  }

}
