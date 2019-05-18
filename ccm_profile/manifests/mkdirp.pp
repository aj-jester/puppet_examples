# This class creates the directory $dir with mkdir -p without creating puppet file resources
# If user and/or group are set, it will execute system commands to ensure the right ownership
# if $dir_is_file is true, then it will remove last part of the path (useful if $dir argument is a file instead of a dir)
define ccm_profile::mkdirp (
  $dir         = $title,
  $user        = undef,
  $group       = undef,
  $dir_is_file = false
  # $mode  = undef # mode cannot be set because, since it's not a managed resource, it would be executed every time
  ) {
  validate_bool($dir_is_file)
  $dir_real = $dir_is_file ? {
    true    => regsubst($dir, '/[^\/]+\/?$', ''),
    default => $dir
  }

  Exec {
    path => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin' }

  if !defined(Exec["mkdir -p ${dir_real}"]) {
    exec { "mkdir -p ${dir_real}": unless => "test -d ${dir_real}" }
  }

  if $dir_is_file and defined(File[$dir]) {
    Exec["mkdir -p ${dir_real}"] -> File[$dir]
  }

  if $user {
    $user_format = is_integer($user) ? {
      true    => 'u',
      default => 'U'
    }

    exec { "chown ${user} ${dir_real}":
      unless  => "test `stat -c %${user_format} ${dir_real}` == ${user}",
      require => Exec["mkdir -p ${dir_real}"]
    }
  }

  if $group {
    $group_format = is_integer($group) ? {
      true    => 'g',
      default => 'G'
    }

    exec { "chgrp ${group} ${dir_real}":
      unless  => "test `stat -c %${group_format} ${dir_real}` == ${group}",
      require => Exec["mkdir -p ${dir_real}"]
    }

  }

}
