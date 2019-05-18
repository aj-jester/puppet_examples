#
# ccm_repo::gluster
#
class ccm_repo::gluster (
  String $ensure  = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_centos-${facts['os']['release']['major']}/${facts['os']['release']['full']}/storage/${facts['os']['architecture']}/gluster-3.12",
  String $gpgkey = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_centos-${facts['os']['release']['major']}/RPM-GPG-KEY-CentOS-SIG-Storage",

){

  yumrepo { 'collectivei-centos-gluster':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => 'Collectivei CentOS Gluster Mirror',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => $gpgkey,
  }

}
