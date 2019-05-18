define ccm_profile::cron::daily (
  $command,
  $ensure      = 'present',
  $minute      = fqdn_rand(60, "${title}_daily_minute"),
  $hour        = fqdn_rand(24, "${title}_daily_hour"),
  $user        = 'root',
  $mode        = '0644',
  $description = "${title} daily job",
  $environment = [],
) {

  cron::daily { "${title}_daily":
    ensure      => $ensure,
    minute      => $minute,
    hour        => $hour,
    user        => $user,
    mode        => $mode,
    command     => $command,
    description => $description,
    environment => $environment,
  }

}
