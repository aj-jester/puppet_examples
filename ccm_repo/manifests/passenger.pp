# Repo for passenger (apache's mod)
class ccm_repo::passenger (
  Enum['absent','present'] $ensure = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_passenger/${facts['os']['release']['major']}/${facts['os']['architecture']}",
) {

  yumrepo { 'collectivei-passenger':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => 'Collectivei Passenger Mirror',
    enabled  => '1',
    gpgcheck => '0',
  }

}
