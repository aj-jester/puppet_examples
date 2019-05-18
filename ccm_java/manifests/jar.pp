define ccm_java::jar (
  $ensure     = 'present',
  $filename   = $title,
  $local_path = '/tmp',
  $repo_path  = 'java/jars',
  $mode       = '0644',
  $owner      = 'root',
  $group      = 'root',
) {

    archive { "${local_path}/${filename}":
      ensure       => $ensure,
      extract      => false,
      extract_path => $local_path,
      source       => "http://repo.${::fqdn_default_location}.ccmteam.com/repo/${repo_path}/${filename}",
    } ->

    file { "${local_path}/${filename}":
      ensure => $ensure,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }

}
