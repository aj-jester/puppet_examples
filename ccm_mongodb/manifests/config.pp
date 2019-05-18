#
# class: ccm_mongodb::config
#
class ccm_mongodb::config {

  include ccm_mongodb

  $notify_service             = $ccm_mongodb::notify_service
  $config_hash                = $ccm_mongodb::config_hash
  $security_authorization_key = $ccm_mongodb::security_authorization_key
  $admin_username             = $ccm_mongodb::admin_username
  $admin_password             = $ccm_mongodb::admin_password

  # Security authorization for replset
  if $security_authorization_key {

    $security_authorization_key_file = '/etc/mongodb-keyfile'

    $security_authorization_config = {
      'security' => {
        'authorization' => 'enabled',
        'keyFile'       => $security_authorization_key_file,
      },
    }

    file { $security_authorization_key_file:
      ensure  => present,
      owner   => 'mongod',
      group   => 'mongod',
      mode    => '0600',
      content => $security_authorization_key,
    }

  } else {
    $security_authorization_config = {}
  }

  # Final YAML hash
  $config_yaml_hash = deep_merge($security_authorization_config, $config_hash)

  ccm_profile::base::vol_dirs { '1': }

  file { $config_hash['storage']['dbPath']:
    ensure  => directory,
    owner   => 'mongod',
    group   => 'mongod',
    mode    => '0755',
  }

  file { '/etc/mongod.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_mongodb/mongod.conf.erb');
  }

  file { '/root/.mongorc.js':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('ccm_mongodb/mongorc.js.erb'),
  }

  ccm_profile::logrotate_rule { 'mongod':
    path          => $config_hash['systemLog']['path'],
    copytruncate  => true,
    ifempty       => false,
    missingok     => true,
    sharedscripts => true,
    postrotate    => "
      /bin/kill -SIGUSR1 $( /bin/cat ${config_hash['storage']['dbPath']}/mongod.lock 2> /dev/null ) 2> /dev/null || true
      /bin/rm -f ${config_hash['systemLog']['path']}.????-??-??T??-??-??
    ",
  }

  # Remove after 04/10/2018 - AJ
  ccm_profile::logrotate_rule { 'mongodb': ensure => 'absent' }

  ccm_profile::tuned { 'mongo-3x': }

  file { '/usr/lib/systemd/system/mongod.service':
    content => template('ccm_mongodb/mongod.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  } ~>

  exec { 'systemctl daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

}
