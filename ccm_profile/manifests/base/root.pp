class ccm_profile::base::root (

  $path = "",

){
  # Simple class to set up things for the root user on every box

  # bash_profile
  file { '/root/.bash_profile':
    owner => 'root',
    group => 'root',
    mode  => '0600',
    content => template('ccm_profile/base/root_bash_profile.erb'),
  }

}
