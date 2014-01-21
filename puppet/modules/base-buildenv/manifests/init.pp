class base-buildenv ($gcc_version = '4.7')  {
  if $gcc_version == '4.8' {
    case $operatingsystem {
    #  ubuntu, debian: {
      ubuntu: {
        class {'base-buildenv::gcc48-package-repo':} ->
        exec { 'gcc update apt-get':
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'apt-get update',
        } ->
        exec {'g++4.8':
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'apt-get install -f -qq --force-yes g++-4.8',
        } ->
        exec {"update-alternatives":
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8',
        }->
         exec {'apt-get-remove':
          path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
          command => 'apt-get autoremove',
         }
      }
      default: {
          warning("g++ ${gcc_version} is not supported yet on ${::operatingsystem} install gcc 4.7 instead")
        package { 'g++':
            ensure => 'latest',
          }
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
