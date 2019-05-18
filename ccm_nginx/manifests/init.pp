class ccm_nginx (
  $package_ensure  = $ccm_nginx::params::package_ensure,
  $package_name    = $ccm_nginx::params::package_name,
  $nginx_upstreams = $ccm_nginx::params::nginx_upstreams,
  $nginx_servers   = $ccm_nginx::params::nginx_servers,
  $http_cfg_append = $ccm_nginx::params::http_cfg_append,
  $server_tokens   = $ccm_nginx::params::server_tokens,

) inherits ccm_nginx::params {

  class { '::nginx':
    package_ensure  => $package_ensure,
    package_name    => $package_name,
    server_tokens   => $server_tokens,
    nginx_upstreams => $nginx_upstreams,
    nginx_servers   => $nginx_servers,
    http_cfg_append => $http_cfg_append,
    manage_repo     => false,
    require         => Package['openssl-libs'],
  }

}
