class ccm_ruby::rh_ruby24 (
  $gems = {},
) {

  ccm_ruby::rh_ruby { 'ruby24':
    ensure_ruby       => "2.4-2.el${::operatingsystemmajrelease}",
    ensure_ruby_devel => "2.4.0-75.el${::operatingsystemmajrelease}",
  }

  create_resources('ccm_ruby::rh_rubygems', $gems, { 'ruby_version' => 'ruby24' })

}
