class ccm_nginx::service::waf {

  include ccm_repo::waf
  include ccm_nginx

  file { '/etc/nginx/naxsi_rules':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Class['ccm_nginx'],
  }

  [

    'fe_gui_dev',
    'intelligence_com_dmz_ops',
    'adas_dmz_ops',
    'webanalytics_intelligence_dmz_ops',
    'collectivei_com_dmz_ops',
    'intelligence_qa_dmz',
    'adas_qa_dmz',
    'webanalytics_qa_dmz',

  ].each |Integer $index, String $template| {

    file { "/etc/nginx/naxsi_rules/${template}.rules":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      content => template("ccm_nginx/naxsi_rules/${template}.rules.erb"),
      require => [Class['ccm_nginx'], File['/etc/nginx/naxsi_rules']],
    }

  }

}
