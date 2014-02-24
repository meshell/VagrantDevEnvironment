class qt5 ()  {
  case $operatingsystem {
    ubuntu: {
      exec {'apt-add-repository-qt5':
        path       => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
        command => 'apt-add-repository -y ppa:ubuntu-sdk-team/ppa',
      } ->
      exec { 'qt5 update apt-get':
        path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
        command => 'apt-get update',
      } ->
      exec {'install-qt5':
        path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
        command => "apt-get install -qq qtdeclarative5-dev qtbase5-dev qtdeclarative5-qtquick2-plugin qtdeclarative5-test-plugin",
      }
    }
    default: {
      warning("Qt5 is not supported yet on ${::operatingsystem}")
    }
  } 

  package {'dbus-x11':
    ensure => 'installed',
  } 
  
  package {'qtcreator':
    ensure => 'installed',
    require  => Package['dbus-x11'],
  }
 
}
