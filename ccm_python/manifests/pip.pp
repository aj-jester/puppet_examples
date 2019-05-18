define ccm_python::pip (
  $ensure = present,
  $url    = false,
  $proxy  = true,
) {

  include ::ccm_python

  if $proxy {
    $real_proxy = $ccm_python::pip_proxy
  } else {
    $real_proxy = false
  }

  python::pip { $title:
    ensure  => $ensure,
    pkgname => $title,
    url     => $url,
    proxy   => $real_proxy,
  }

}
