#
# ccm_repo::postgresql
#
class ccm_repo::postgresql (
  Enum['absent','present'] $ensure  = 'present',
  String $baseurl                   = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_postgresql/${facts['os']['release']['major']}/9.6/${facts['os']['architecture']}",
  String $gpgkey                    = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_postgresql/${facts['os']['release']['major']}/RPM-GPG-KEY-PGDG-96",
) {

  yumrepo { 'collectivei-postgresql':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => "Collectivei PostgreSQL Mirror",
    gpgkey   => $gpgkey,
    gpgcheck => '1',
    enabled  => '1',
  }

}
