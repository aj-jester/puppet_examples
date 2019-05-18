define ansible::playbook (
  $module = $caller_module_name,
  $ensure = 'present',
  $owner  = 'root',
  $group  = 'root',
  $mode   = '0644',
) {

  require ansible

  file { "/etc/ansible/playbooks/${title}.yaml":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template("${module}/${title}.yaml.ansible.playbook.erb"),
  }

}
