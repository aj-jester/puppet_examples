class ccm_profile::gluster::client (
  String $repo_ensure    = 'present',
  String $package_ensure = 'present',
) {

  class { 'ccm_repo::gluster':
    ensure => $repo_ensure,
  }

  package { ['glusterfs', 'glusterfs-fuse']:
    ensure  => $package_ensure,
    require => Class['ccm_repo::gluster'],
  }

}
