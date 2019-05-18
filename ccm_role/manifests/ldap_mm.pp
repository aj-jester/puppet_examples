class ccm_role::ldap_mm {
  # empty role not to have site.pp complain
  include ccm_profile::ldap::server
}
