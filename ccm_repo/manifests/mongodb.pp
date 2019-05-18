#
# ccm_repo::mongodb
#
class ccm_repo::mongodb (
  Enum['absent','present'] $ensure  = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_mongodb/${facts['os']['release']['major']}/3.6/${facts['os']['architecture']}",
  String $gpgkey = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_mongodb/${facts['os']['release']['major']}/3.6/server-3.6.asc",
) {

  yumrepo { 'collectivei-mongodb':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => "Collectivei MongoDB Mirror",
    gpgkey   => $gpgkey,
    gpgcheck => '1',
    enabled  => '1',
  }

}
