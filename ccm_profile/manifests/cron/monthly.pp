define ccm_profile::cron::monthly (
  $command,
  $ensure      = 'present',
  $minute      = fqdn_rand(60, "${title}_monthly_minute"),
  $hour        = fqdn_rand(24, "${title}_monthly_hour"),
  $date        = fqdn_rand(27, "${title}_monthly_date"),
  $user        = 'root',
  $mode        = '0644',
  $description = "${title} monthly job",
  $environment = [],
) {

  cron::monthly { "${title}_monthly":
    ensure      => $ensure,
    minute      => $minute,
    hour        => $hour,
    date        => $date,
    user        => $user,
    mode        => $mode,
    command     => $command,
    description => $description,
    environment => $environment,
  }

}
