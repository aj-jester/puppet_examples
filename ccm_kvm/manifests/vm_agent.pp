class ccm_kvm::vm_agent (
  String $ensure = 'present',
) {

  include ccm_repo::ovirt

  package { 'ovirt-guest-agent-common':
    ensure  => $ensure,
    require => Class['ccm_repo::ovirt'],
  } ->

  service { 'ovirt-guest-agent':
    ensure => running,
    enable => true,
  }

}
