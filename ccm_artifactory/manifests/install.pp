class ccm_artifactory::install {

  include ccm_artifactory
  include ccm_repo::collectivei

  include ccm_java::eight
  include ccm_profile::gluster::client
  include ccm_nginx::service::artifactory

  ensure_packages(['rsync'])

  Class[
    'ccm_java::eight',
    'ccm_repo::collectivei',
    'ccm_profile::gluster::client',
  ] ->

  Package['rsync'] ->

  package { 'jfrog-artifactory-pro':
    ensure => $ccm_artifactory::ensure,
  } ->

  ccm_java::jar { 'mariadb-java-client-2.2.3.jar':
    local_path => '/opt/jfrog/artifactory/tomcat/lib',
    mode       => '0775',
  } ->

  file { '/mnt/artifactory':
    ensure => directory,
    owner  => 'artifactory',
    group  => 'artifactory',
  }

}
