class ccm_profile::systemd::systemctl_daemon_reload {

  # Class for systemd operations that may be required in other modules

  exec { 'systemd_reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }

}
