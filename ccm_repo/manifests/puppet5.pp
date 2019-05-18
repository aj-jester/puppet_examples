# Puppet mirrors
class ccm_repo::puppet5 (
  Enum['absent','present'] $ensure = 'present',
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_puppet/five/${facts['os']['release']['major']}/${facts['os']['architecture']}",
){

    yumrepo { 'collectivei-puppet5':
      ensure   => $ensure,
      baseurl  => $baseurl,
      descr    => 'Collectivei Puppet 5 Mirror',
      enabled  => '1',
      gpgcheck => '0',
    }

}
