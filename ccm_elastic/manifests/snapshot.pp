class ccm_elastic::snapshot {

  # Pull in the common ES dependencies
  include ccm_elastic::common

  file { '/opt/ccm/bin/backup_es_cinews.sh':
    ensure  => 'present',
    source  => 'puppet:///modules/ccm_elastic/site_elk/backup_es_cinews.sh',
    owner   => $::ccm_elastic::common::user,
    group   => $::ccm_elastic::common::user,
    mode    => '0755',
    require => File['/opt/ccm/bin'],
  }

  if $ccm_elastic::common::es_snapshot_host == $fqdn {
    cron { 'backup_es_cinews':
      command => '/opt/ccm/bin/backup_es_cinews.sh',
      user    => $::ccm_elastic::common::user,
      hour    => 1,
      minute  => 15,
    }
  }
}
