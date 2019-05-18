class ccm_profile::sudo (

  # setting the default sudoers to an empty string.
  # this will be filled in from hiera.
  $ccm_default_config = "",

){
  # Sudo through hiera will only work if we define content in the environment, hence, until we can move sudo to LDAP, we will pull files locally to ccm_profile.
  class { 'sudo': }
  sudo::conf { 'ccm':
    content => $ccm_default_config,
  }

  if $::fqdn_provider == 'g' {
    sudo::conf { 'google':
      content => '%google-sudoers ALL=(ALL:ALL) NOPASSWD:ALL',
    }
  }

  if $::fqdn_location == 'vbox' {
    sudo::conf { 'vagrant':
      content => 'vagrant ALL=(ALL:ALL) NOPASSWD:ALL',
    }
  }
}
