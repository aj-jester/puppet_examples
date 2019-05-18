define ccm_java::scala (
  Enum['absent','present'] $ensure = 'present',
  $version      = $title,
  $tarball_path = "/tmp/scala-${version}.tar.gz",
  $tarball_url  = "http://repo.${::fqdn_location}.ccmteam.com/repo/java/scala/scala-${version}.tar.gz",
) {

  include ccm_java::common::scala

  $extract_path = $ccm_java::common::scala::extract_path

  if $ensure == 'present' {

    archive { $tarball_path:
      path         => $tarball_path,
      source       => $tarball_url,
      extract_path => $extract_path,
      creates      => "${extract_path}/scala-${version}/bin/scala",
      extract      => true,
      cleanup      => true,
    }

  } elsif $ensure == 'absent' {

    exec { "remove_scala_${version}":
      command => "/usr/bin/rm -rf ${extract_path}/scala-${version}",
      onlyif  => "/usr/bin/test -d ${extract_path}/scala-${version}",
    }

  }

}
