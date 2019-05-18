#
# ccm_artifactory::config
#
class ccm_artifactory::config {

  include ccm_artifactory

  $filestore = $ccm_artifactory::filestore

  file {
    '/etc/opt/jfrog/artifactory/binarystore.xml':
      ensure  => present,
      owner   => 'artifactory',
      group   => 'artifactory',
      mode    => '0770',
      content => template('ccm_artifactory/binarystore.xml.erb');

    '/opt/jfrog/artifactory/tomcat/conf/server.xml':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0775',
      source => 'puppet:///modules/ccm_artifactory/tomcat.server.xml';
  }

}
