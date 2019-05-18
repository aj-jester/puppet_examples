class ccm_puppet::eyaml (
  $gem_install_options = [],
) {

  package {[
    'hiera-eyaml',
    'hiera-eyaml-gpg',
    'ruby_gpg',
  ]:
    ensure             => present,
    provider           => puppetserver_gem,
    install_options    => $gem_install_options,
  }

}
