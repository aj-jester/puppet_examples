class ccm_pgsql::cluster::sysone (
  $replication_username = undef,
  $replication_password = undef,
  $master_ip            = undef,
  $slave_ip             = undef,
  $slave_name           = undef,
) {

  include ccm_pgsql

  $config_entries = $ccm_pgsql::config_entries
  $archive_dir_path = $ccm_pgsql::archive_dir_path

  # If archiving is 'on' we will assume this is the Master
  if $config_entries['archive_mode']['value'] == 'on' {

    file { $archive_dir_path:
      ensure => directory,
      owner  => 'postgres',
      group  => 'postgres',
      mode   => '0700',
    }

    postgresql::server::pg_hba_rule { 'Localhost 127.0.0.1/32':
      description => 'Open PgSQL Localhost 127.0.0.1/32',
      type        => 'host',
      database    => 'replication',
      user        => 'replica',
      address     => '127.0.0.1/32',
      auth_method => 'md5',
    }

    postgresql::server::pg_hba_rule { "Master ${master_ip}/32":
      description => "Open PgSQL Master ${master_ip}/32",
      type        => 'host',
      database    => 'replication',
      user        => 'replica',
      address     => "${master_ip}/32",
      auth_method => 'md5',
    }

    postgresql::server::pg_hba_rule { "Slave ${slave_ip}/32":
      description => "Open up PgSQL Slave ${slave_ip}/32",
      type        => 'host',
      database    => 'replication',
      user        => 'replica',
      address     => "${slave_ip}/32",
      auth_method => 'md5',
    }

  # Else its a Slave.
  } else {

    postgresql::server::recovery { 'recovery.conf':
      standby_mode     => 'on',
      primary_conninfo => "host=${master_ip} port=5432 user=${replication_username} password=${replication_password} application_name=${slave_name}",
      trigger_file     => '/tmp/postgresql.trigger.5432',
    }

  }

}
