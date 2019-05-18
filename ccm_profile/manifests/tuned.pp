#
# ccm_profile::tuned
#
define ccm_profile::tuned {

  class { '::tuned':
    profile => $title,
    source  => "puppet:///modules/ccm_profile/tuned/${title}",
  }

}
