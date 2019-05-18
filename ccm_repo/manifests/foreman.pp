class ccm_repo::foreman (
  $baseurl  = "http://artifact.${facts['fqdn_default_location']}.ccmteam.com/rpm_foreman",
  $enabled  = 1,
  $gpgcheck = 0,
) {

  exec { 'remove foreman repos':
    command => '/bin/rm /etc/yum.repos.d/foreman*.repo && /usr/bin/yum clean expire-cache',
    onlyif  => '/usr/bin/test -f /etc/yum.repos.d/foreman*.repo',
  } ->

  yumrepo { 'collectivei-foreman':
    baseurl  => "${baseurl}/foreman-el${facts['os']['release']['major']}",
    descr    => 'Collectivei Foreman Mirror',
    enabled  => $enabled,
    gpgcheck => $gpgcheck,
    gpgkey   => "${baseurl}/RPM-GPG-KEY-foreman",
  } ->

  yumrepo { 'collectivei-foreman-plugins':
    baseurl  => "${baseurl}/foreman-plugins-el${facts['os']['release']['major']}",
    descr    => 'Collectivei Foreman Plugins Mirror',
    enabled  => $enabled,
    gpgcheck => $gpgcheck,
    gpgkey   => "${baseurl}/RPM-GPG-KEY-foreman",
  }

}
