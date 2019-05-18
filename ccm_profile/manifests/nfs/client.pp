class ccm_profile::nfs::client (
  String $ensure = 'present',
) {

  package { 'nfs-utils':
    ensure  => $ensure,
  }

}
