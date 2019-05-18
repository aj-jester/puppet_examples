class ccm_nginx::service::artifactory {

  include ccm_nginx

  file { '/etc/nginx/sites-enabled/artifactory.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_nginx/artifactory.conf.erb'),
    notify  => Class['::nginx::service'],
  }

}
