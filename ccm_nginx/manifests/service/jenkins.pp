class ccm_nginx::service::jenkins {

  include ccm_nginx

  file { '/etc/nginx/sites-enabled/jenkins.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_nginx/jenkins.conf.erb'),
    notify  => Class['::nginx::service'],
  }

}
