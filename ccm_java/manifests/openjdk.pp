define ccm_java::openjdk (
  Enum['absent','present'] $ensure = 'present',
  $version      = $title,
  $tarball_path = "/tmp/openjdk-${version}_linux-x64_bin.tar.gz",
  $tarball_url  = "http://repo.${::fqdn_location}.ccmteam.com/repo/java/openjdk/openjdk-${version}_linux-x64_bin.tar.gz",
) {

  include ccm_java::common::openjdk

  $extract_path = $ccm_java::common::openjdk::extract_path

  if $ensure == 'present' {

    archive { $tarball_path:
      path         => $tarball_path,
      source       => $tarball_url,
      extract_path => $extract_path,
      creates      => "${extract_path}/jdk-${version}/bin/java",
      extract      => true,
      cleanup      => true,
    }

  } elsif $ensure == 'absent' {

    exec { "remove_openjdk_${version}":
      command => "/usr/bin/rm -rf ${extract_path}/jdk-${version}",
      onlyif  => "/usr/bin/test -d ${extract_path}/jdk-${version}",
    }

  }

}
