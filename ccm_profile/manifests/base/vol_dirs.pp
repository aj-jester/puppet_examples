define ccm_profile::base::vol_dirs {

  $vol_id = "vol${title}"

  file { [

      "/${vol_id}",

      "/${vol_id}/tmp",

      "/${vol_id}/var",
      "/${vol_id}/var/lib",
      "/${vol_id}/var/log",

    ]:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
  }

}
