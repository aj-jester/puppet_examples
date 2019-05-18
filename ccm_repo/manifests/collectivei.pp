#
# ccm_repo::collectivei
#
class ccm_repo::collectivei (
  Enum['absent','present'] $ensure  = 'present',
  String $baseurl_x86_64            = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_collectivei/${facts['os']['release']['major']}/x86_64",
  String $baseurl_noarch            = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_collectivei/${facts['os']['release']['major']}/noarch",
) {

  yumrepo { 'collectivei-packages-x86-64':
    ensure   => $ensure,
    baseurl  => $baseurl_x86_64,
    descr    => "Collectivei Packages x86_64",
    enabled  => '1',
    gpgcheck => '0',
  }

  yumrepo { 'collectivei-packages-noarch':
    ensure   => $ensure,
    baseurl  => $baseurl_noarch,
    descr    => "Collectivei Packages noarch",
    enabled  => '1',
    gpgcheck => '0',
  }

}
