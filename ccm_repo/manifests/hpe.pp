class ccm_repo::hpe (
  $spp_baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_hpe/spp/${facts['os']['release']['major']}/${facts['os']['architecture']}/2017.04.0",
  $spp_gpgkey  = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_hpe/spp/GPG-KEY-SPP",
  $enabled     = 1,
  $gpgcheck    = 0,
) {

  yumrepo { 'collectivei-hpe-spp':
    baseurl  => $spp_baseurl,
    descr    => 'Collectivei HPE SPP Mirror',
    enabled  => $enabled,
    gpgcheck => $gpgcheck,
    gpgkey   => $spp_gpgkey,
  }

}
