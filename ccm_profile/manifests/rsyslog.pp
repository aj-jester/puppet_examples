class ccm_profile::rsyslog (
  $log_local        = 'true',
  $log_remote       = false,
  $remote_servers   = false,
  $log_local_custom = '',

){
  class { ::rsyslog::client:
    log_local        => $log_local,
    log_local_custom => $log_local_custom,
    log_remote       => $log_remote,
    remote_servers   => $remote_servers,
  }
}
