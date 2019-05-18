class ccm_role::ldap_server {
  # empty role not to have site.pp complain
  include ccm_profile::ldap::server
}
