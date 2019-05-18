define ccm_ruby::rh_ruby (
  $ensure_ruby       = present,
  $ensure_ruby_devel = present,
) {

  package { "rh-${title}":
    ensure  => $ensure_ruby,
    require => Class['ccm_repo::sclo'],
  }

  package { "rh-${title}-ruby-devel":
    ensure  => $ensure_ruby_devel,
    require => Class['ccm_repo::sclo'],
  }

}
