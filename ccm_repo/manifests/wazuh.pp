# Local wazuh mirror
class ccm_repo::wazuh(
  Enum['absent','present'] $ensure = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_wazuh/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  String $gpgkey  = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_wazuh/GPG-KEY-WAZUH",
) {

  yumrepo { 'collectivei-wazuh':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => 'Collective Wazuh Mirror',
    gpgkey   => $gpgkey,
    gpgcheck => '1',
    enabled  => '1',
  }

}
