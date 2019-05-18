class ccm_profile::ldap (

  $auth_default = 'ipa'

){

  # Determine authentication source and include the appropriate module
  case $auth_default {
    'openldap': {
      include ccm_profile::ldap::centos
    }
    'ipa': {
      include ccm_profile::ldap::ipa_client
    }
    'none': {
      # noop
    }
    default: {
      notify { 'Central authentication scheme not selected. This should not happen.': }
    }
  }
}
