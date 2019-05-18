class ccm_java::eight (
  $version_major = '131',
  $version_minor = 'b11',
){

  $home = "/usr/java/jre1.8.0_${version_major}"
  $bin  = "${home}/bin/java"

  java::oracle { 'java_8' :
    ensure        => 'present',
    oracle_url    => "http://repo.${::fqdn_default_location}.ccmteam.com/repo/java/jre",
    version_major => "8u${version_major}",
    version_minor => $version_minor,
    java_se       => 'jre',
  }

}
