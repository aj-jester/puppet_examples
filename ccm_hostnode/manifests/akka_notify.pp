class ccm_hostnode::akka_notify {

  # Java
  class { 'ccm_java::common::openjdk':
    default_version => '10.0.2'
  }

  ccm_java::openjdk { '10.0.2': }

  # Scala
  class { 'ccm_java::common::scala':
    default_version => '2.11.2'
  }

  ccm_java::scala { '2.11.2': }

  # SM-3012 Does not know how to use vi
  if $facts['app_env'] in ['dev', 'stg'] {
    ensure_packages(['nano'])
  }

}
