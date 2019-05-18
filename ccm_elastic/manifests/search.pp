class ccm_elastic::search (

){
  # Pull in the common ES dependencies
  include ccm_elastic::common

  anchor { 'ccm_elastic::search::begin': } ->
  Class['ccm_elastic::common'] ->
  class { 'elasticsearch':
    manage_repo        => false,
    elasticsearch_user => $::ccm_elastic::common::user,
    version            => $::ccm_elastic::common::version,
    init_defaults      => $::ccm_elastic::common::init_defaults,
    config             => $::ccm_elastic::common::config,
    jvm_options        => $::ccm_elastic::common::es_jvm_options,
    restart_on_change  => $::ccm_elastic::common::restart_on_change,
  }                                       ->
  elasticsearch::instance { "${::ccm_elastic::common::clustername}":
    datadir => ["${::ccm_elastic::common::es_data_dir}/${::ccm_elastic::common::clustername}" ],
  } ->

  # Stopwords and Synonyms
  file { "${::ccm_elastic::common::es_data_dir}/extra_config":
    ensure  => directory,
    owner   => $::ccm_elastic::common::user,
    group   => $::ccm_elastic::common::user,
    require => Class['elasticsearch'],
  }                                       ->
  file { "${::ccm_elastic::common::es_data_dir}/extra_config/stopwords.txt":
    ensure  => 'present',
    source  => 'puppet:///modules/ccm_elastic/site_elk/stopwords.txt',
    owner   => $::ccm_elastic::common::user,
    group   => $::ccm_elastic::common::user,
    require => File["${::ccm_elastic::common::es_data_dir}/extra_config/"],
  }                                       ->
  file { "${::ccm_elastic::common::es_data_dir}/extra_config/synonyms.txt":
    ensure  => 'present',
    source  => 'puppet:///modules/ccm_elastic/site_elk/synonyms.txt',
    owner   => $::ccm_elastic::common::user,
    group   => $::ccm_elastic::common::user,
    require => File["${::ccm_elastic::common::es_data_dir}/extra_config/"],
  }                                       ->
  anchor { 'ccm_elastic::search::end': }

  if $::ccm_elastic::common::curator {
    include ccm_elastic::curator
  }

}
