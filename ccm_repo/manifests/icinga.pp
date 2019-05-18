#
# ccm_repo::icinga
#
class ccm_repo::icinga (
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_icinga/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  String $gpgkey = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_icinga/RPM-GPG-KEY-Icinga",
) {

  yumrepo { 'collectivei-icinga':
    baseurl  => $baseurl,
    descr    => 'Collectivei Icinga Mirror',
    gpgkey   => $gpgkey,
    enabled  => '1',
    gpgcheck => '1',
  }

}
