class ccm_nodejs::common (

  $nvm_dir        = '/opt/nodejs',
  $dest_dir_owner = 'root',
  $dest_dir_group = 'root',

){

  $dest_dir = "${nvm_dir}/versions/node"
  ccm_profile::mkdirp { $dest_dir: } ->
  file { [$nvm_dir, $dest_dir, "${dest_dir}/bin"]:
    ensure => directory,
    owner  => $dest_dir_owner,
    group  => $dest_dir_group,
    mode   => '0755',
  }

  file { "${dest_dir}/bin/nvm.sh":
      ensure => file,
      source => 'puppet:///modules/ccm_nodejs/nvm.sh',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
  }

  $user_profile = $dest_dir_owner ? {
  # it should never be this but at least we avoid the
  # error in case there's no hiera value for appuid key
    'root'  => '/root/.bash_profile_node',
    default => "/home/${dest_dir_owner}/.bash_profile"
  }

  ensure_resource('file', $user_profile, {'ensure' => 'present'})

  file_line { "${dest_dir_owner}_bashrc_nodejs_NVM_DIR":
    ensure  => present,
    line    => "export NVM_DIR=${nvm_dir}",
    path    => $user_profile,
    require => File[$user_profile],
  }

  file_line { "${dest_dir_owner}_bashrc_nodejs_NVM_SOURCE":
    ensure  => present,
    line    => "source ${dest_dir}/bin/nvm.sh",
    path    => $user_profile,
    require => File[$user_profile],
  }

}
