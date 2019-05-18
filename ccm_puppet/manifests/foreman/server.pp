# foreman hosts
class ccm_puppet::foreman::server (
  $admin_password        = undef,
  $db_password           = undef,
  $oauth_consumer_key    = undef,
  $oauth_consumer_secret = undef,
  $settings_root_pass    = undef,
) {

  include ccm_certs::wildcard_ccmteam_com
  include ccm_certs::gd_bundle_g1_g2
  include ccm_puppet::server
  include ccm_puppet::foreman::backup

  include ccm_repo::passenger

  class {'foreman':
    admin_email           => 'systems@collectivei.com',
    admin_password        => $admin_password,
    configure_epel_repo   => false,
    configure_scl_repo    => false,
    custom_repo           => true,
    db_manage             => false,
    db_adapter            => 'postgresql',
    db_host               => 'pgsql-sysone.ops.iad1.ccmteam.com',
    db_port               => 5432,
    db_database           => 'ppt_foreman',
    db_username           => 'ppt_foreman',
    db_password           => $db_password,
    email_smtp_address    => "smtp.${facts[ccm_dc]}.ccmteam.com",
    email_smtp_port       => 25,
    foreman_url           => 'https://ppt-foreman.ccmteam.com',
    locations_enabled     => true,
    oauth_consumer_key    => $oauth_consumer_key,
    oauth_consumer_secret => $oauth_consumer_secret,
    organizations_enabled => false,
    puppetrun             => true,
    server_ssl_cert       => $ccm_certs::wildcard_ccmteam_com::cert_path,
    server_ssl_chain      => $ccm_certs::gd_bundle_g1_g2::cert_path,
    server_ssl_key        => $ccm_certs::wildcard_ccmteam_com::key_path,
    serveraliases         => [
      "ppt-foreman.${facts[ccm_dc]}.ccmteam.com",
      'ppt-foreman.ccmteam.com',
      "foreman-${facts[ccm_dc]}.ccmteam.com",
    ],
    websockets_encrypt    => true,
    websockets_ssl_cert   => $ccm_certs::wildcard_ccmteam_com::cert_path,
    websockets_ssl_key    => $ccm_certs::wildcard_ccmteam_com::key_path,
    }

  # We could use foreman::settings class but the options there are limited
  # so we create a hash and we use create_resources with foreman_config_entry type
  $foreman_settings = {
    'administrator'                         => { 'value' => 'systems@collectivei.com' },
    'root_pass'                             => { 'value' => $settings_root_pass },
    'safemode_render'                       => { 'value' => false },
    'puppet_server'                         => { 'value' => "ppt-server.${facts[ccm_dc]}.ccmteam.com"},
    'update_ip_from_built_request'          => { 'value' => false },
    'ignore_puppet_facts_for_provisioning'  => { 'value' => true },
  }
  create_resources('foreman_config_entry', $foreman_settings)

  # foreman_proxy is now included in the puppet profile

  # install hammer packages (cli) & plygins
  ensure_packages (
    [
      'foreman-vmware',
      'foreman-ovirt',
      'tfm-rubygem-hammer_cli_foreman',
      'tfm-rubygem-hammer_cli_foreman_admin',
      'tfm-rubygem-hammer_cli_foreman_remote_execution',
      'tfm-rubygem-hammer_cli_foreman_ssh',
    ]
  )

  # Expire OK Foreman Puppet reports once a day.
  ccm_profile::cron::daily { 'foreman_reports_expire':
    command => '/usr/sbin/foreman-rake reports:expire days=1 status=0',
  }

}
