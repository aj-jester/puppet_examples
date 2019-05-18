class ccm_profile::limits {

  include ::limits

  limits::limits { 'root/nofile':
    both => '1048575',
  }

  limits::limits { 'root/nproc':
    both => 'unlimited',
  }

  limits::limits { '*/nofile':
    both => '1048575',
  }

  limits::limits { '*/nproc':
    both => 'unlimited',
  }

}
