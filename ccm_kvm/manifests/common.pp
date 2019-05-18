class ccm_kvm::common {

  include ccm_repo::ovirt
  include ccm_repo::gluster

  file { '/etc/sudoers.d/11_vdsm':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('ccm_kvm/vdsm.sudoers.erb'),
  }

}
