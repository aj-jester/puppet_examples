#
# Class: ccm_consul::params
#
class ccm_consul::params {
  $version             = '1.2.2'
  $download_url_base   = "http://repo.${::fqdn_location}.ccmteam.com/repo/hashicorp/consul/"
  $user                = 'consul'
  $group               = 'consul'
  $restart_on_change   = false
  $install             = false
  $add_config          = {}
  $rpc_tls             = false
  $enable_backup       = false
  $backup_consul_mount = '/opt/consul/backups'
  $backup_consul_token = '00000000-0000-0000-0000-000000000000' 

  $base_config    =  {
    data_dir             => '/opt/consul',
    datacenter           => $::fqdn_location,
    log_level            => 'info',
    node_name            => $::fqdn,
    disable_update_check => true,
    acl_datacenter       => $::fqdn_location,
    acl_token            => '00000000-0000-0000-0000-000000000000',
    acl_down_policy      => 'extend-cache',
    raft_protocol        => 3,
    protocol             => 3,
    advertise_addr       => $::ccm_ipaddress, # needed for servers with multiple IPs, like docker ones
  }

}
