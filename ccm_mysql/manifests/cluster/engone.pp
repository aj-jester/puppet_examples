class ccm_mysql::cluster::engone {

  include ccm_mysql

  Class['ccm_mysql'] ->

  class { '::mysql::server':
    package_manage   => false,
    root_password    => $ccm_mysql::root_password,
    override_options => $ccm_mysql::override_options,
  }

}
