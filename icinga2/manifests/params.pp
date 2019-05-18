#
# icinga2::params
#
class icinga2::params {

  $ensure            = "2.9.1-1.el${::operatingsystemmajrelease}.icinga"
  $install_module    = false
  $node_type         = 'client'
  $master_host       = undef
  $satellite_hosts   = []
  $ticket_salt       = undef
  $restart_on_change = true
  $api_creds         = {}
  $cmd_creds         = {}

  $sudoers           = {
                       'DEFAULT' => [ '/bin/true', '/bin/false *' ],
                     }

}
