class ccm_profile::physical::hpe {

  include ccm_repo::hpe
  include ccm_profile::physical::raid

  Class['ccm_repo::hpe'] ->

  package { [ 'hp-ams', 'hp-health', 'hp-snmp-agents', 'hponcfg' ]: }

}
