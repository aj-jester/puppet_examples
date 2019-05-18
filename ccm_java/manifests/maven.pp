define ccm_java::maven (
  Enum['absent','present'] $ensure = 'present',
  $version      = $title,
  $tarball_path = "/tmp/apache-maven-${version}-bin.tar.gz",
  $tarball_url  = "http://repo.${::fqdn_location}.ccmteam.com/repo/java/maven/apache-maven-${version}-bin.tar.gz",
) {

  include ccm_java::common::maven

  $extract_path = $ccm_java::common::maven::extract_path

  if $ensure == 'present' {

    archive { $tarball_path:
      path         => $tarball_path,
      source       => $tarball_url,
      extract_path => $extract_path,
      creates      => "${extract_path}/apache-maven-${version}/bin/mvn",
      extract      => true,
      cleanup      => true,
    } ->

    file { "${extract_path}/apache-maven-${version}/conf/settings.xml":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('ccm_java/maven/settings.xml.erb'),
    }

  } elsif $ensure == 'absent' {

    exec { "remove_maven_${version}":
      command => "/usr/bin/rm -rf ${extract_path}/apache-maven-${version}",
      onlyif  => "/usr/bin/test -d ${extract_path}/apache-maven-${version}",
    }

  }

}
