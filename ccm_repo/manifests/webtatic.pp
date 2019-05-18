#
# ccm_repo::webtatic
#
class ccm_repo::webtatic (
  Enum['absent','present'] $ensure  = 'present',
  String $baseurl                   = "http://repo.${::fqdn_default_location}.ccmteam.com/repo/webtatic_el${facts['os']['release']['major']}/el${facts['os']['release']['major']}/${facts['os']['architecture']}",
) {

  yumrepo { 'collectivei-webtatic':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => 'Collectivei webtatic',
    gpgcheck => '0',
    enabled  => '1',
  }

}
