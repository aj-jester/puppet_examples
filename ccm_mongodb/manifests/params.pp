#
# class: ccm_mongodb::params
#
class ccm_mongodb::params {

  $package_name               = 'server'
  $package_ensure             = 'present'
  $config_hash                = {}
  $restart_on_change          = true
  $security_authorization_key = undef
  $admin_username             = 'ccmadmin'
  $admin_password             = undef

}
