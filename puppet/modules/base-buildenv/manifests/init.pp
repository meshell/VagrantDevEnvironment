class base-buildenv ($gcc_version = '4.7')  {

  if $gcc_version == '4.8' {
    case $::operatingsystem {
      'Debian','Ubuntu': {
        exec {'apt-add-repository-toolchain':
          path       => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
          command => 'apt-add-repository -y ppa:ubuntu-toolchain-r/test',
        }

        exec { 'update apt-get':
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'apt-get update',
          require     => Exec['apt-add-repository-toolchain'],
        }

        exec {'g++4.8':
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => "apt-get install -f -qq --force-yes g++-4.8",
          require    => Exec['update apt-get'],
        }

        exec {"update-alternatives":
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8',
          require     => Exec['g++4.8'],
        }
 
        exec {'apt-get-remove':
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'apt-get autoremove',
          require     => Exec['update-alternatives'],
        }
      }
      default: {
        fail("g++ ${gcc_version} is not supported yet on ${::operatingsystem}")
      }
    }
  } else {
    package { 'g++':
      ensure => $gcc_version,
    }
  }

  package { 'make':
    ensure => 'installed',
  }

  package { 'cmake':
    ensure => 'installed',
  }
}
