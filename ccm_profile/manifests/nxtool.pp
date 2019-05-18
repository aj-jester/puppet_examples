class ccm_profile::nxtool {

  ccm_python::pip { 'elasticsearch':
    ensure => '5.5.2',
  }
  ccm_python::pip { 'elasticsearch-dsl':
    ensure => '5.4.0'
  }

  ensure_packages([
    'pcre-devel',
  ])

}
