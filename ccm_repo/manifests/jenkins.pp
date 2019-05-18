#
# ccm_repo::jenkins
#
class ccm_repo::jenkins (
  Enum['absent','present'] $ensure = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_jenkins/${facts['os']['release']['major']}/noarch",
  String $gpgkey = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_jenkins/RPM-GPG-KEY-Jenkins",
) {

  yumrepo { 'collectivei-jenkins':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => "Collectivei Jenkins Mirror",
    gpgkey   => $gpgkey,
    gpgcheck => '1',
    enabled  => '1',
  }

}
