#
# ccm_repo::cassandra
#
class ccm_repo::cassandra (
  Enum['absent','present'] $ensure  = 'present',
  String $baseurl                   = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/311x",
  String $gpgkey                    = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/KEYS",
) {

  yumrepo { 'collectivei-cassandra':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => "Collectivei Cassandra Mirror",
    gpgkey   => $gpgkey,
    gpgcheck => '1',
    enabled  => '1',
  }

}
