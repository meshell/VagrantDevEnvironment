exec { 'apt-get update':
  command => '/usr/bin/apt-get update';
}

package { 'make':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}

package { 'g++':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}

package { 'cucumber':
    ensure => 'installed',
    provider => 'gem',
    require => Package['make'];
}

package { 'cppcheck':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}

package { 'git':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}

package { 'subversion':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}

package { 'cmake':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}

package { 'firefox':
    ensure => 'installed',
    require  => Exec['apt-get update'];
}
