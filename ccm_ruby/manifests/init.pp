#
# Class: ccm_ruby (default ruby version)
#
class ccm_ruby (
  $default_ruby = 'ruby24',
) {

  class { "ccm_ruby::rh_${default_ruby}": } ->

  file { '/etc/profile.d/enable-ruby.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ccm_ruby/enable-ruby.sh.erb'),
  }

}
