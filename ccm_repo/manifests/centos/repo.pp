# Defined type that actually define the yumrepo
define ccm_repo::centos::repo (
  Variant[String, Stdlib::Compat::String] $baseurl,
  Optional[String]                        $gpgkey   = undef,
  Enum['absent','present']                $ensure   = 'present',
  Variant[String, Stdlib::Compat::String] $descr    = "CentOS ${facts['os']['release']['full']} ${title} Mirror",
  Integer[0,1]                            $enabled  = 1,
  Integer[0,1]                            $gpgcheck = 1,
) {

  yumrepo { "collectivei-centos-${title}":
    ensure   => $ensure,
    baseurl  => $baseurl,
    descr    => $descr,
    enabled  => $enabled,
    gpgcheck => $gpgcheck,
    gpgkey   => $gpgkey,
  }
}
