#
# ccm_artifactory::service
#
class ccm_artifactory::service {

  service { 'artifactory':
    ensure => running,
    enable => true,
  }

}
