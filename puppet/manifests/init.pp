class {'base-buildenv':
  gcc_version => '4.8',
  before => Package['qtcreator'],
}

$user_developer = 'developer'
$user_pwd = '$6$hLUKVOmi$CjXrA8oL9e/3irGl.b3uOllQBgD4P2kjcR3i/EYXfdhLD/5wg./sYO5PccanbEiN1sB6gBFLhslQAEkJjwhd.0'
$repo_name = 'KarateTournamentManger'
$repo_url = 'https://github.com/meshell/KarateTournamentManager.git'
$git_author_name = 'Michel Estermann'
$git_author_email = 'estermann.michel@gmail.com'


exec {'apt-get update':
  path       => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'],
  command => 'apt-get update',
}

package {'git':
  ensure    => 'installed',
}

# Configure Git
exec {'git-author-name':
  command => "/usr/bin/git config --global user.name '${git_author_name}'",
  require    => Package['git'],
  unless    => "/usr/bin/git config --global --get user.name|grep '${git_author_name}'",
}

exec {'git-author-email':
  command => "/usr/bin/git config --global user.email '${git_author_email}'",
  require    => Package['git'],
  unless    => "/usr/bin/git config --global --get user.email|grep '{$git_author_email}'",
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
}

user {"${user_developer}":
  ensure        => present,
  comment      => 'Developer',
  gid              => $user_developer,
  shell            => '/bin/bash',
  home           => "/home/${user_developer}",
  managehome => true,
  password      => $user_pwd,
  require          => Group["${user_developer}"],
}

vcsrepo {"/home/$user_developer/${repo_name}":
    ensure => present,
    provider => git,
    source  => $repo_url,
    revision => 'master',
    require  => Package['git'],
    user      => $user_developer,
}

# Dependencies

Exec['apt-get update'] -> Package <| |>
User['developer']  -> Vcsrepo <| |>
