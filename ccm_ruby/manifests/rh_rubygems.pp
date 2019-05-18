define ccm_ruby::rh_rubygems (
  $ensure,
  $ruby_version,
) {

  include ccm_ruby::common

  package { "${ruby_version}-${title}":
    ensure          => $ensure,
    name            => $title,
    provider        => "rh_${ruby_version}_gem",
    install_options => $ccm_ruby::common::gem_install_options,
    require         => Ccm_ruby::Rh_ruby[$ruby_version];
  }

}
