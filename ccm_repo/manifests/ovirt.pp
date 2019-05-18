#
# ccm_repo::ovirt
#
class ccm_repo::ovirt (
  Enum['absent','present'] $ensure_ovirt           = 'absent',
  Enum['absent','present'] $ensure_virt_kvm_common = 'absent',
  Enum['absent','present'] $ensure_virt_ovirt      = 'present',

  String $baseurl_ovirt            = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_ovirt/${facts['os']['release']['major']}/4.2",
  String $baseurl_virt_kvm_common  = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_centos-${facts['os']['release']['major']}/${facts['os']['release']['full']}/virt/${facts['os']['architecture']}/kvm-common",
  String $baseurl_virt_ovirt       = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_centos-${facts['os']['release']['major']}/${facts['os']['release']['full']}/virt/${facts['os']['architecture']}/ovirt-4.2",

  String $gpgkey_ovirt             = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_ovirt/RPM-GPG-ovirt-v2",
  String $gpgkey_virt_kvm_common   = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_centos-${facts['os']['release']['major']}/RPM-GPG-KEY-CentOS-SIG-Virtualization",
  String $gpgkey_virt_ovirt        = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_centos-${facts['os']['release']['major']}/RPM-GPG-KEY-CentOS-SIG-Virtualization",
) {

  yumrepo { 'collectivei-ovirt':
    ensure   => $ensure_ovirt,
    baseurl  => $baseurl_ovirt,
    descr    => 'Collectivei oVirt Mirror',
    gpgkey   => $gpgkey_ovirt,
    gpgcheck => '1',
    enabled  => '1',
  }

  ccm_repo::centos::repo { 'virt-kvm-common':
    ensure  => $ensure_virt_kvm_common,
    baseurl => $baseurl_virt_kvm_common,
    gpgkey  => $gpgkey_virt_kvm_common,
  }

  ccm_repo::centos::repo { 'virt-ovirt':
    ensure  => $ensure_virt_ovirt,
    baseurl => $baseurl_virt_ovirt,
    gpgkey  => $gpgkey_virt_ovirt,
  }

}
