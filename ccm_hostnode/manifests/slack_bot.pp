class ccm_hostnode::slack_bot (

  $pip_packages = undef,
  $slack_token  = 'xoxb-xxxxx-xxxxxx-xxxxxxx',
  $vo_api_id    = 'xxxx-xxxxx-xxxxxx',
  $vo_api_key   = 'xxxx-xxxxx-xxxxxx',
  $botname      = 'bender',
  $bot_avatar   = 'https://a1cf74336522e87f135f-2f21ace9a6cf0052456644b80fa06d4f.ssl.cf2.rackcdn.com/images/characters/p-futurama-john-di-maggio.jpg',
  $proxy        = 'proxy.stg.iad1.ccmteam.com:3128',
  $tag          = '0.1.1',

){

  ensure_packages('git') 
  create_resources('::ccm_python::pip', $pip_packages) 

  group { 'slack_bot':
    ensure => present,
    gid    => '1389',
  } ->

  user { 'slack_bot':
    ensure => present,
    gid    => '1389',
  } ->

  file { '/opt/slack_bot':
    ensure => directory,
    owner  => 'slack_bot',
    group  => 'slack_bot',
    mode   => '750',
  } ->

  vcsrepo { '/opt/slack_bot':
    ensure   => present,
    source   => 'https://git.ccmteam.com/scm/sm/ccm_slackbot.git',
    revision => $tag,
    provider => git,
    require  => [
      Package['git']],
  } ->

  file { '/opt/slack_bot/settings.py':
    ensure => present,
    owner  => 'slack_bot',
    group  => 'slack_bot',
    mode   => '750',
    content => template('ccm_hostnode/slack_bot/settings.py.erb'),
  } ->

  file { "/etc/systemd/system/slack_bot.service":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('ccm_hostnode/slack_bot/slack_bot.service.erb'),
    notify  => Class['ccm_profile::systemd::systemctl_daemon_reload'],
  }

  service { 'slack_bot':
    ensure => 'running',
    enable => true,
  }

}
