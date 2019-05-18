class ccm_python (
  $pip_proxy = false,
){

  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'absent',
    virtualenv => 'absent',
    gunicorn   => 'absent',
    use_epel   => false,
  }

}
