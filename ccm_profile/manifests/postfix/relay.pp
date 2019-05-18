class ccm_profile::postfix::relay (
  $enable_postfix_relay = true,
  $smtp_relay           = "mailhub.${::fqdn_default_location}.ccmteam.com",
){
  # Simple postfix configuration for all servers except mail hosts
  if $enable_postfix_relay {
    include postfix
    postfix::config { 'relay_domains':
      ensure  => present,
      value   => "localhost ${::fqdn}",
    }
    postfix::config { 'relayhost':
      ensure  => present,
      value   => $smtp_relay,
    }
  }
}
