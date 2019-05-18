# Repo for waf (nginx-naxsi)

class ccm_repo::waf (
  Enum['absent','present'] $ensure  = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_waf/${facts['os']['release']['major']}",
) {

  yumrepo { 'collectivei-waf':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => 'Collectivei WAF Packages',
    enabled  => '1',
    gpgcheck => '0',
  }

}
