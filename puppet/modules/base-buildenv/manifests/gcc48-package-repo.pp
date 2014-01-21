class base-buildenv::gcc48-package-repo () {
  case $operatingsystem {
    ubuntu: {
      exec {'apt-add-repository-toolchain':
        path       => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
        command => 'apt-add-repository -y ppa:ubuntu-toolchain-r/test',
      } 
    } 
    debian: {
      augeas { 'debian-testing':
        context => "/files/etc/apt/sources.list",
        changes => [
          "set *[distribution = 'wheezy']/distribution 'testing'",
        ],
      }
    }
    default: {
      warning("g++ ${gcc_version} is not supported yet on ${::operatingsystem} install gcc 4.7 instead")
    }
  }
}