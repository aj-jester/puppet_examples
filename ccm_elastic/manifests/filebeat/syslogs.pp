class ccm_elastic::filebeat::syslogs (

){
  # Pull in the common ES dependencies
  include ccm_elastic::common

  class { 'filebeat':
    major_version  => $::ccm_elastic::common::filebeat_major,
    package_ensure => $::ccm_elastic::common::version,
    manage_repo    => $::ccm_elastic::common::filebeat_manage_repo,
    spool_size     => $::ccm_elastic::common::filebeat_spool_size,
    outputs        => $::ccm_elastic::common::filebeat_outputs,
  }
    
  filebeat::prospector { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/syslog',
      '/var/log/messages',
      '/var/log/mail',
      '/var/log/secure',
    ],
    doc_type => 'syslog-beat',
  }

}

