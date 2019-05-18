class ccm_cassandra::service {

  service { 'cassandra':
    ensure => running,
    enable => true,
  }

}
