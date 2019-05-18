class ccm_elastic::install {

# Class to ensure basic system stuff is available with the elastic products.

  group { 'elkadmin':
    gid      => 716,
    before   => User['elkadmin']
  }

  user { 'elkadmin':
    home     => "/home/elkadmin",
    ensure   => 'present',
    uid      => 716,
    gid      => 716,
    shell    => '/usr/bin/bash',
    password => '*',
  }

  file { "/home/elkadmin":
    ensure  => directory,
    mode    => '0750', owner => $user, group => $user,
    require => User['elkadmin']
  }

}
