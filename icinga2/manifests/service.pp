#
# icinga2::service
#
class icinga2::service {

  service { 'icinga2':
    ensure => running,
    enable => true,
  }

}
