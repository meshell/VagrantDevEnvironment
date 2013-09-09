# Class: sonar-runner
#
# This module manages sonar-runner
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class sonar-runner (
  $version = '2.3',
  $user = 'sonar',
  $group = 'sonar',
  $user_system = true,
  $installroot = '/usr/local',
  $port = 9000, $download_url = 'http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist', 
  $context_path = '/', $arch = '',
  $jdbc = {
    url               => 'jdbc:mysql://localhost:3306/sonar?useUnicode=true&amp;characterEncoding=utf8',
    username          => 'sonar',
    password          => 'sonar',
  })
{
  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin'
  }
  File {
    owner => $user,
    group => $group
  }
 
  # wget from https://github.com/maestrodev/puppet-wget
  include wget
  
  # calculate in what folder is the binary to use for this architecture
  $arch1 = $::kernel ? {
    'windows' => 'windows',
    'sunos'   => 'solaris',
    'darwin'  => 'macosx',
    default   => 'linux',
  }
  if $arch1 != 'macosx' {
    $arch2 = $::architecture ? {
      'x86_64' => 'x86-64',
      'amd64'  => 'x86-64',
      default  => 'x86-32',
    }
  } else {
    $arch2 = $::architecture ? {
      'x86_64' => 'universal-64',
      default  => 'universal-32',
    }
  }
  $bin_folder = $arch ? {'' => "${arch1}-${arch2}", default => $arch }

  $installdir = "${installroot}/sonar-runner"
  $tmpzip = "/usr/local/src/sonar-runner-${version}.zip"

  if ! defined(Package[unzip]) {
    package { unzip:
      ensure => present,
      before => Exec[sonar-runner-untar]
    }
  }
  
  wget::fetch {
    'download-sonar-runner':
      source      => "${download_url}/${version}/sonar-runner-dist-${version}.zip",
      destination => $tmpzip,
  } ->
  
  # ===== Create folder structure =====
  
  file { "${installroot}/sonar-runner-${version}":
    ensure => directory,
  } ->
  file { $installdir:
    ensure => link,
    target => "${installroot}/sonar-runner-${version}",
  } ->
  
  exec { 'sonar-runner-untar':
    command => "unzip -o ${tmpzip} -d ${installroot} && chown -R ${user}:${group} ${installroot}/sonar-runner-${version}",
    creates => "${installroot}/sonar-runner-${version}/bin",
  } ->
  
  # Sonar-runner configuration files
  file { "${installdir}/conf/sonar-runner.properties":
    content => template('sonar-runner/sonar-runner.properties.erb'),
    require => Exec['sonar-runner-untar'],
  } ->
  
  file { "${installroot}/bin/sonar-runner":
    ensure => link,
    target => "${installdir}/bin/sonar-runner",
  }
  
 
  file {'/etc/profile.d/sonar-runner.sh':
    content => inline_template("export SONAR_RUNNER_HOME=<%= installdir %>")
  }
}
