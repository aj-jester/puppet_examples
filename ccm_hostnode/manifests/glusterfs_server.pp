class ccm_hostnode::glusterfs_server (

  $peer        = undef,
  $volume      = undef,
  $replica     = undef,
  $bricks      = undef,
  $options     = undef,
  ){

  if ($peer == undef) {
    fail('Gluster peers not defined! Hiera problem?')
  }

  if ($volume == undef) {
    fail('Gluster volume not defined! Hiera problem?')
  }

  if ($replica == undef) {
    fail('Gluster replica not defined! Hiera problem?')
  }

  if ($bricks == undef) {
    fail('Gluster bricks not defined! Hiera problem?')
  }

  if ($options == undef) {
    fail('Gluster option not defined! Hiera problem?')
  }

  include ccm_repo::gluster

  package { 'glusterfs-server':
    ensure  => present,
    require => Class['ccm_repo::gluster'],
  }

  class { gluster:
    server                 => true,
    client                 => true,
    repo                   => false,
    use_exported_resources => false,
  }

  gluster::peer { $peer:
    pool    => $peer_pool,
    require => Class[::gluster::service],
  }

#  This is commented out for now, initally we will only use gluster on a couple of infrastructure servers for backup storage.
#  We need an aribter node in order to have qourum without losting an entire servers worth of storage. 
#  See: http://docs.gluster.org/en/latest/Administrator%20Guide/Split%20brain%20and%20ways%20to%20deal%20with%20it/
#  If it becomes more widely used, consider using hiera to turn this feature on/off is it will set up the volume. 
#
#  gluster::volume { $volume:
#    require => Gluster::Peer[$peer],
#    replica => $replica,
#    bricks  => $bricks,
#    options => $options,
#  }
}
