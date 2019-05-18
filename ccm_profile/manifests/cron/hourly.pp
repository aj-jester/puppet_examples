define ccm_profile::cron::hourly (
  $command,
  $ensure      = 'present',
  $minute      = fqdn_rand(60, "${title}_hourly_minute"),
  $user        = 'root',
  $mode        = '0644',
  $description = "${title} hourly job",
  $environment = [],
) {

  cron::hourly { "${title}_hourly":
    ensure      => $ensure,
    minute      => $minute,
    user        => $user,
    mode        => $mode,
    command     => $command,
    description => $description,
    environment => $environment,
  }

}
