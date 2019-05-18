class ccm_hostnode::waf_proxy {

  include ccm_nginx::service::waf

  Class['ccm_nginx::service::waf'] ->

  file { '/etc/rsyslog.d/naxsi.conf': 
    owner           => 'root',
    group           => 'root',
    mode            => '0644',
    content         => 'local4.*                       -/var/log/nginx/naxsi_rsyslog.log',
  } ~>

  Class['::rsyslog::service']

  ccm_profile::logrotate_rule { 'naxsi_rsyslog':
    path          => '/var/log/nginx/naxsi_rsyslog.log',
    ifempty       => false,
    missingok     => true,
    sharedscripts => true,
    postrotate    => '
      /bin/kill -USR1 `cat /run/nginx.pid 2>/dev/null` 2>/dev/null || true
      /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
    ',
    require => File['/etc/rsyslog.d/naxsi.conf'],
  }

  class{ 'ccm_wazuh::agent':
    ossec_config_profiles => ['waf-proxy']
  }

}
