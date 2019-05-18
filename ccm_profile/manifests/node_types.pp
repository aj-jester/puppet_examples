class ccm_profile::node_types {

  if $facts['is_virtual'] {

    include ccm_profile::virtual::common

    case $facts['virtual'] {
      'kvm':        { include ccm_profile::virtual::kvm }
      'gce':        { include ccm_profile::virtual::gce }
      'vmware':     { include ccm_profile::virtual::vmware }
      'virtualbox': { include ccm_profile::virtual::virtualbox }
      default:      { fail("Unsupported virtual type: ${facts['virtual']}") }
    }

  } elsif $facts['virtual'] == 'physical' {

    include ccm_profile::physical::common

    case $facts['dmi']['manufacturer'] {
      'HP':                { include ccm_profile::physical::hpe }
      'Dell Inc.':         { include ccm_profile::physical::dell }
      'Penguin Computing': { include ccm_profile::physical::penguin }
      'Intel Corporation': { include ccm_profile::physical::intel }
      default:             { fail("Unsupported physical type: ${facts['dmi']['manufacturer']}") }
    }

  }

}
