# EPEL repo
class ccm_repo::epel (
  String $baseurl = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_epel/${facts['os']['release']['major']}/${facts['os']['architecture']}",
  String $gpgkey = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_epel/RPM-GPG-KEY-EPEL-${facts['os']['release']['major']}",

  ){

  yumrepo { 'collectivei-epel':
    baseurl  => $baseurl,
    descr    => 'Collectivei EPEL Mirror',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => $gpgkey,
  }

  exec { 'Remove all the default epel repo files':
    command => '/bin/rm /etc/yum.repos.d/epel*.repo && /usr/bin/yum clean all',
    onlyif  => '/bin/ls /etc/yum.repos.d/epel*.repo'
  }
}
