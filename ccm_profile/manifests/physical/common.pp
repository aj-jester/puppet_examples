class ccm_profile::physical::common {

  ensure_packages([
    'freeipmi',
    'ipmitool',
    'mcelog',
  ])

}
