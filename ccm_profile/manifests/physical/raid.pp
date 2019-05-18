class ccm_profile::physical::raid {

  case $facts['ccm_raid'] {

    'adaptec': {

      Class['ccm_repo::collectivei'] ->

      package { ['Arcconf']: }

    }

    'megaraid': {

      Class['ccm_repo::collectivei'] ->

      package { ['MegaCli', 'storcli']: }

    }

    'smartarray': {

      Class['ccm_repo::hpe'] ->

      package { ['ssacli']: }

    }

    'mdadm': { }

    'none': {

      notify { 'This is a physical node but no raid devices found.': }

    }

    default: {

      if $facts['raid_count'] > 0 {

        notify { "Unsupported RAID vendor ${facts['raid_vendor0']}": }

      } else {

        notify { 'This is a physical node but no raid devices found.': }

      }

    }

  }

}
