class ccm_repo::elastic (
  Enum['absent','present'] $ensure = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_elastic/six",
  String $gpgkey  = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_elastic/GPG-KEY-elasticsearch",
){

  yumrepo { 'collectivei-elastic':
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => 'Collectivei Elastic Mirror',
    enabled  => '1',
    gpgcheck => '1',
    gpgkey   => $gpgkey,
  }

  yumrepo { 'collectivei-elastic-repo': ensure => absent }

}
