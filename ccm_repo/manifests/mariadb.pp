#
# ccm_repo::mariadb
#
class ccm_repo::mariadb (
  Enum['absent','present'] $ensure = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_mariadb/${facts['os']['release']['major']}/10.2/${facts['os']['architecture']}",
  String $gpgkey = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_mariadb/RPM-GPG-KEY-MariaDB",
) {

  yumrepo { 'collectivei-mariadb':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => "Collectivei MariaDB Mirror",
    gpgkey   => $gpgkey,
    gpgcheck => '1',
    enabled  => '1',
  }

}
