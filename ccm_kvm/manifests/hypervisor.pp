class ccm_kvm::hypervisor {

  include ccm_kvm::common
  include ccm_profile::firewalld

  ccm_profile::base::vol_dirs { '1': }

  file { '/vol1/ovirt_data':
    ensure => directory,
    owner  => 'vdsm',
    group  => 'kvm',
    mode   => '0755',
  }

  $hv_services = ['cockpit', 'libvirt-tls', 'vdsm', 'ovirt-imageio', 'ovirt-vmconsole']

  $hv_services.each |String $hv_service| {
    firewalld_service { "Allow ${hv_service}":
      ensure  => 'present',
      service => $hv_service,
      zone    => 'public',
    }
  }

}
