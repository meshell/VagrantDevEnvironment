class {'base-buildenv':
  gcc_version => '4.8',
} 

class {'qt5':
 }

$user_developer = 'developer'
$user_pwd = '$6$hLUKVOmi$CjXrA8oL9e/3irGl.b3uOllQBgD4P2kjcR3i/EYXfdhLD/5wg./sYO5PccanbEiN1sB6gBFLhslQAEkJjwhd.0'
$repo_name = 'KarateTournamentManager'
$repo_url = 'https://github.com/meshell/KarateTournamentManager.git'
$git_author_name = 'Michel Estermann'
$git_author_email = 'estermann.michel@gmail.com'


exec {'apt-get update':
  path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
  command => 'apt-get update',
} ->
exec {'safe-upgrade':
  path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
  command => 'aptitude -y -f safe-upgrade',
  timeout     => 1800,
}

package {'cucumber':
  ensure => 'installed',
  provider => 'gem',
}

package {'cppcheck':
  ensure => 'installed',
}

package {'rats':
  ensure => 'installed',
}

package {'valgrind':
  ensure => 'installed',
}

package {'subversion':
  ensure => 'installed',
}

package {'firefox':
  ensure => 'installed',
}

package {'emacs':
  ensure => 'installed',
}

package {'pcmanfm':
  ensure => 'installed',
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
} ->

augeas { "sudodeveloper":
  context => "/files/etc/sudoers",
  changes => [
    "set spec[user = '${user_developer}']/user ${user_developer}",
    "set spec[user = '${user_developer}']/host_group/host ALL",
    "set spec[user = '${user_developer}']/host_group/command ALL",
    "set spec[user = '${user_developer}']/host_group/command/runas_user ALL",
  ],
}

package {'git':
  ensure    => 'installed',
} ->

package {'gitk':
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

class { 'sonar' : 
  version     => '3.7', 
  jdbc         => $jdbc,
} 

include wget

# Install cxx plugin manualy

$cxx_plugin_download_url = 'http://repository.codehaus.org/org/codehaus/sonar-plugins/cxx/sonar-cxx-plugin'
$cxx_plugin_version='0.9'

wget::fetch { 'download-cxx_plugin':
  source      => "${cxx_plugin_download_url}/${cxx_plugin_version}/sonar-cxx-plugin-${cxx_plugin_version}.jar",
  destination => "${sonar::home}/extensions/plugins/sonar-cxx-plugin-${cxx_plugin_version}.jar",
  notify     => Service['sonar'],
}


#sonar::plugin { 'sonar-cxx-plugin' :
# groupid    => 'org.codehaus.sonar-plugins',
#  artifactid => 'sonar-cxx-plugin',
#  version    => '0.9',
#  notify     => Service['sonar'],
#} 

class {'sonar-runner' :
  version     => '2.3', 
  jdbc         => $jdbc,
}

package {'eclipse-cdt':
  ensure    => 'installed',
  require => Class['java'],
} 


# Dependencies

Exec['safe-upgrade'] -> Package <| |>
User['developer']  -> Vcsrepo <| |>
