#
# icinga2::install
#
class icinga2::install {

  include icinga2

  class { 'ccm_repo::icinga':} ->

  package { 'icinga2':
    ensure => $icinga2::ensure,
  }

}
