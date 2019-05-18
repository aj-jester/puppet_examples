class ccm_profile::base::packages {

  # Alphabetical order
  $packages = [
    'bzip2',
    'htop',
    'lshw',
    'lsof',
    'lsscsi',
    'net-tools',
    'openssl',
    'openssl-libs',
    'pciutils',
    'pigz',
    'redhat-lsb-core',
    'strace',
    'telnet',
    'tmux',
    'tree',
    'unzip',
    'vim',
    'wget',
    'zip',
  ]

  ensure_packages($packages, { 'require' => Ccm_repo::Centos::Repo['os'] })

}
