class ccm_profile::git (
  $ensure  = 'installed',

){

  package { 'git':
    ensure => $ensure ,
  }

}
