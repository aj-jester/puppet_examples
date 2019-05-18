#
# class: ccm_jenkins::build_dependencies
#
class ccm_jenkins::build_dependencies {

  include ccm_jenkins

  # Build essentails, make, gcc, g++, bison, etc..
  include ccm_profile::base::build_dependencies

  # NodeJS 
  include ccm_nodejs
  create_resources('ccm_nodejs::node_install', { 'v8.11.3'=>{} })

  # BC
  ensure_packages(['bc'])

  # OpenJDK
  class { 'ccm_java::common::openjdk':
    default_version => '1.8.0_181'
  }

  ccm_java::openjdk { '1.8.0_181': }
  ccm_java::openjdk { '10.0.2': }


  # Maven
  class { 'ccm_java::common::maven':
    default_version => '3.5.4'
  }

  ccm_java::maven { '3.5.4': }

  # Scala
  class { 'ccm_java::common::scala':
    default_version => '2.11.2'
  }

  ccm_java::scala { '2.11.2': }

  # Sbt
  class { 'ccm_java::common::sbt':
    default_version => '1.2.1'
  }

  ccm_java::sbt { '1.2.1': }

   # git
  class { 'ccm_profile::git':
    ensure => '2.17.0-1.el7.lux',
  }

}
