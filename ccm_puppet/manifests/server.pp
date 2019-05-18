#
# ccm_puppet::server
#
class ccm_puppet::server {

  include ccm_repo::puppet5
  include puppet
  include ccm_puppet::hiera
  include ccm_certs::wildcard_ccmteam_com

  anchor { 'ccm_puppet::server::begin': } ->
  Class['ccm_repo::puppet5'] ->
  Class['puppet'] ->
  class { 'ccm_repo::foreman': } ->
  class { 'ccm_puppet::r10k': } ->
  class { 'ccm_puppet::eyaml': } ->
  class { 'foreman_proxy': } ->
  anchor { 'ccm_puppet::server:end': }

}
