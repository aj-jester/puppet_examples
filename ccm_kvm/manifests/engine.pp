class ccm_kvm::engine (
  $ovirt_engine_db_name  = undef,
  $ovirt_engine_db_host  = undef,
  $ovirt_engine_db_user  = undef,
  $ovirt_engine_db_pass  = undef,
  $ovirt_history_db_name = undef,
  $ovirt_history_db_host = undef,
  $ovirt_history_db_user = undef,
  $ovirt_history_db_pass = undef,
  $ovirt_backup_config   = undef,
  $ovirt_backup_user     = undef,
  $ovirt_backup_pass     = undef,
  $ovirt_engine_api_host = undef, 
) {

  include ccm_kvm::common

  file { '/etc/ovirt-engine/engine.conf.d/10-setup-database.conf':
    ensure  => present,
    mode    => '0640',
    owner   => 'ovirt',
    group   => 'ovirt',
    content => template('ccm_kvm/10-setup-database.conf.engine.erb'),
    notify  => Service['ovirt-engine'],
  }

  file { '/etc/ovirt-engine/engine.conf.d/10-setup-dwh-database.conf':
    ensure  => present,
    mode    => '0640',
    owner   => 'ovirt',
    group   => 'ovirt',
    content => template('ccm_kvm/10-setup-dwh-database.conf.erb'),
    notify  => Service['ovirt-engine-dwhd'],
  }

  file { '/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf':
    ensure  => present,
    mode    => '0640',
    owner   => 'ovirt',
    group   => 'ovirt',
    content => template('ccm_kvm/10-setup-database.conf.dwdh.erb'),
    notify  => Service['ovirt-engine', 'ovirt-engine-dwhd'],
  }

  service {[
    'ovirt-engine',
    'ovirt-engine-dwhd',
  ]:
      ensure => running,
      enable => true,
  }

  # provide backup support for oVirt
  archive { "oVirtBackup.tar":
    path         => "/tmp/oVirtBackup.tar",
    source       => 'http://repo.iad1.ccmteam.com/repo/ovirtbackup/oVirtBackup.tar',
    extract      => true,
    extract_path => '/etc',
    cleanup      => true,
  }

  create_resources('::ccm_kvm::vm_backup', $ovirt_backup_config)

}
