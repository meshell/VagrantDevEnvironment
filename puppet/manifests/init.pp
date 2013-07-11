class {'base-buildenv':
  gcc_version => '4.8',
  before => Package['qtcreator'],
}

$user_developer = 'developer'
$user_pwd = '$6$hLUKVOmi$CjXrA8oL9e/3irGl.b3uOllQBgD4P2kjcR3i/EYXfdhLD/5wg./sYO5PccanbEiN1sB6gBFLhslQAEkJjwhd.0'
$repo_name = 'AgileEmbeddedDevelopmentExample'
$repo_url = 'git@github.com:meshell/AgileEmbeddedDevelopmentExample.git'
$git_author_name = 'Michel Estermann'
$git_author_email = 'estermann.michel@gmail.com'


exec {'apt-get update':
  path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
  command => 'apt-get update',
}

package {'cucumber':
  ensure => 'installed',
  provider => 'gem',
}

package {'cppcheck':
  ensure => 'installed',
}

package {'subversion':
  ensure => 'installed',
}

package {'firefox':
  ensure => 'installed',
}
package {'dbus-x11':
  ensure => 'installed',
}

package {'qtcreator':
  ensure => 'installed',
  require  => Package['dbus-x11'],
}

group {"${user_developer}":
  ensure => present,
} ->

user {"${user_developer}":
  ensure        => present,
  comment      => 'Developer',
  gid              => $user_developer,
  shell            => '/bin/bash',
  home           => "/home/${user_developer}",
  managehome => true,
  password      => $user_pwd,
}

package {'git':
  ensure    => 'installed',
} ->

# Configure Git
exec {'git-author-name':
  command => "/usr/bin/git config --global user.name '${git_author_name}'",
  unless    => "/usr/bin/git config --global --get user.name|grep '${git_author_name}'",
} ->

exec {'git-author-email':
  command => "/usr/bin/git config --global user.email '${git_author_email}'",
  unless    => "/usr/bin/git config --global --get user.email|grep '{$git_author_email}'",
} ->

vcsrepo {"/home/$user_developer/${repo_name}":
    ensure => present,
    provider => git,
    source  => $repo_url,
    revision => 'master',
    require  => Package['git'],
    user      => $user_developer,
}

# +++++++++++++++++
# Sonar
# +++++++++++++++++
$sonar_user= 'sonar'
$sonar_pwd= 'sonar'

$jdbc = {
  url               => 'jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true',
  driver_class_name => 'com.mysql.jdbc.Driver',
  validation_query  => 'select 1',
  username          => $sonar_user,
  password          => $sonar_pwd,
}

class { 'mysql::server':
  config_hash => { 'root_password' => 'password' }
} ->

class { 'mysql::java': 
} ->

mysql::db { 'sonar':
  user     => $sonar_user,
  password => $sonar_pwd,
  host     => 'localhost',
  grant    => ['all'],
} ->

class {'java':
} ->

class {'maven::maven': }  ->

class { 'sonar' : 
  version     => '3.6', 
  jdbc         => $jdbc,
} 

sonar::plugin { 'sonar-cxx-plugin' :
  groupid    => 'org.codehaus.sonar-plugins',
  artifactid => 'sonar-cxx-plugin',
  version    => '0.2',
  notify     => Service['sonar'],
}

# Dependencies

Exec['apt-get update'] -> Package <| |>
User['developer']  -> Vcsrepo <| |>
