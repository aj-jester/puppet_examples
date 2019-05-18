class ansible (
  $ensure = 'installed',
) {

  anchor { 'ansible::begin': } ->

  package { 'ansible': ensure => $ensure } ->
  
  file {
    '/etc/ansible/ansible.cfg':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('ansible/ansible.cfg.erb');
    '/etc/ansible/inventory':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
    '/etc/ansible/inventory/foreman.py':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/ansible/inventory/foreman.py';
  } ->

  file { '/etc/ansible/playbooks':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  anchor { 'ansible::end': }

}
