# Install ccm mirrros of centos
class ccm_repo::centos (
  Boolean $repo_os           = true,
  Boolean $repo_updates      = true,
  Boolean $repo_sclo         = true,
  Boolean $repo_rh           = true,
  Boolean $repo_extras       = false,
  Boolean $repo_opstools     = false,
  Boolean $repo_centosplus   = false,
  Boolean $repo_cr           = false,
  String $baseurl_os         = '',
  String $baseurl_updates    = '',
  String $baseurl_centosplus = '',
  String $baseurl_cr         = '',
  String $baseurl_extras     = '',
  String $baseurl_sclo       = '',
  String $baseurl_rh         = '',
  String $baseurl_opstools   = '',
  String $gpgkey             = '',
  String $gpgkey_opstools    = '',
) {

  if $repo_os {
    ccm_repo::centos::repo { 'os': 
    baseurl => $baseurl_os,
    gpgkey  => $gpgkey,
    }
  }

  if $repo_updates {
    ccm_repo::centos::repo { 'updates': 
    baseurl => $baseurl_updates,
    gpgkey  => $gpgkey,
    }
  }

  if $repo_centosplus {
    ccm_repo::centos::repo { 'centosplus': 
    baseurl => $baseurl_centosplus,
    gpgkey  => $gpgkey,
    }
  }

  if $repo_cr {
    ccm_repo::centos::repo { 'cr': 
    baseurl => $baseurl_cr,
    gpgkey  => $gpgkey,
    }
  }

  if $repo_extras {
    ccm_repo::centos::repo { 'extras': 
    baseurl => $baseurl_extras,
    gpgkey  => $gpgkey,
    }
  }

  if $repo_sclo {
    ccm_repo::centos::repo { 'sclo': 
    baseurl => $baseurl_sclo,
    gpgcheck => 0,
    }
  }

  if $repo_rh {
    ccm_repo::centos::repo { 'rh': 
    baseurl => $baseurl_rh,
    gpgcheck => 0,
    }
  }

  if $repo_opstools {
    ccm_repo::centos::repo { 'opstools':
      baseurl => $baseurl_opstools,
      gpgkey  => $gpgkey_opstools,
    }
  }

}
