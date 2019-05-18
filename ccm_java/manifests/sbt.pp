define ccm_java::sbt (
  Enum['absent','present'] $ensure = 'present',
  $version      = $title,
  $tarball_path = "/tmp/sbt-${version}.tar.gz",
  $tarball_url  = "http://repo.${::fqdn_location}.ccmteam.com/repo/java/sbt/sbt-${version}.tar.gz",
) {

  include ccm_java::common::sbt

  $extract_path = $ccm_java::common::sbt::extract_path

  if $ensure == 'present' {

    archive { $tarball_path:
      path         => $tarball_path,
      source       => $tarball_url,
      extract_path => $extract_path,
      creates      => "${extract_path}/sbt-${version}/bin/sbt",
      extract      => true,
      cleanup      => true,
    }

  } elsif $ensure == 'absent' {

    exec { "remove_sbt_${version}":
      command => "/usr/bin/rm -rf ${extract_path}/sbt-${version}",
      onlyif  => "/usr/bin/test -d ${extract_path}/sbt-${version}",
    }

  }

}
