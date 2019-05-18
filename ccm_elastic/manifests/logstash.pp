class ccm_elastic::logstash (

  # logstash plugins fail when not executed by user 'logstash'.
  # Elkadmin is a carry over from the old stack and probably should
  # have been re-evaluated.

  $user     = $::ccm_elastic::common::user,

){

  include ccm_elastic::common

  class { 'logstash':
    settings          => $::ccm_elastic::common::logstash_settings,
    version           => $::ccm_elastic::common::version,
    logstash_user     => $::ccm_elastic::logstash::user,
    jvm_options       => $::ccm_elastic::common::logstash_jvm_options,
    restart_on_change => $::ccm_elastic::common::logstash_restart_on_change,
    manage_repo       => false,
  }
  logstash::configfile { 'logstash.conf':
    template      => ("ccm_elastic/logstash/${ccm_elastic::common::logstash_config_template}")
  }

  if $::ccm_elastic::common::logstash_slack_hook {
    logstash::plugin { 'logstash-output-slack':
      environment   => $::ccm_elastic::common::logstash_environment,
    }
  }

  if $::ccm_elastic::common::logstash_log4j_plugin {
    logstash::plugin { 'logstash-input-log4j':
      environment   => $::ccm_elastic::common::logstash_environment,
    }
  }

  if $::ccm_elastic::common::logstash_environment {
    file { '/etc/sysconfig/logstash':
      ensure  => present,
      content => $::ccm_elastic::common::logstash_environment,
    }
  }
 
  if $::ccm_elastic::common::logstash_settings['path.queue'] {
    ccm_profile::base::vol_dirs { '1': } ->
    file { "${::ccm_elastic::common::logstash_settings['path.queue']}":
      ensure  => directory,
      owner   => $::ccm_elastic::logstash::user,
      group   => $::ccm_elastic::logstash::user,
    }
  }

  file { '/var/log/logstash': 
    ensure        => directory,
    owner         => $::ccm_elastic::logstash::user,
    group         => $::ccm_elastic::logstash::user,
  }

}
