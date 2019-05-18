* This module contains all custom profiles for Redhat's Tuned

More information at these links:

 - https://servicesblog.redhat.com/2012/04/16/tuning-your-system-with-tuned/
 - https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/performance_tuning_guide/sect-red_hat_enterprise_linux-performance_tuning_guide-performance_monitoring_tools-tuned_and_tuned_adm

We are currently using thias/tuned from the puppet forge (https://github.com/thias/puppet-tuned)

There are no manifests, rather you may pull in your configuration in the systems role (ccm_role)

  class { '::tuned':
    profile => 'elasticsearch-tune',
    source  => 'puppet:///modules/ccm_system/tune-profiles/ccm-hp-db-es-tune',
    profile_path => '/usr/lib/tuned'
  }
