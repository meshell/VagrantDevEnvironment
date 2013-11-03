class base-buildenv::gcc48-package-repo () {
  if $operatingsystem == ubuntu {
    exec {'apt-add-repository-toolchain':
      path       => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
      command => 'apt-add-repository -y ppa:ubuntu-toolchain-r/test',
    } 
  } elseif $operatingsystem == debian {
    augeas { 'debian-testing':
      context => "/files/etc/apt/sources.list",
      changes => [
        "set *[distribution = 'wheezy']/distribution 'testing'",
      ],
    }
  }
}