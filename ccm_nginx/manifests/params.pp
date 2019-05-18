class ccm_nginx::params {

  $package_ensure  = 'present'
  $package_name    = 'nginx'
  $server_tokens   = 'off'
  $nginx_upstreams = {}
  $nginx_servers   = {}
  $http_cfg_append = {}
}
