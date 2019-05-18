#
# ccm_profile::base
#
class ccm_profile::base {

  include ccm_repo::centos
  include ccm_repo::epel
  include ccm_puppet::agent
  include ccm_profile::base::dirs
  include ccm_profile::base::packages
  include ccm_profile::node_types
  include ccm_profile::pip
  include ccm_profile::limits
  include ccm_profile::ssh
  include ccm_profile::ldap
  include ccm_profile::sudo
  include ccm_profile::base::root
  include ccm_repo::collectivei
  include ccm_profile::systemd::systemctl_daemon_reload
  include ::ntp
  include ::cron
  include ccm_consul
  include ccm_ruby
  include ccm_profile::rsyslog
  include ::logrotate
  include icinga2
  include ccm_profile::postfix::relay
  include ccm_profile::base::motd
  include ccm_crypt

}
