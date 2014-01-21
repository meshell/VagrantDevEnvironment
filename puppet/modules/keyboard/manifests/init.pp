class keyboard (
  $keyboard_model     = 'pc105',
  $keyboard_layout    = 'us',
  $keyboard_variant   = '',
  $keyboard_options   = '',
  $keyboard_backspace = 'guess'
) {

  package { 'keyboard-configuration':
    ensure => present
  } ->

  augeas { 'keyboard-layout':
    context => "/files/etc/default/keyboard",
    changes => [
      "set XKBMODEL $keyboard_model",
      "set XKBLAYOUT $keyboard_layout",
      "set XKBVARIANT '$keyboard_variant'",
      "set XKBOPTIONS '$keyboard_options'",
      "set BACKSPACE $keyboard_backspace",
    ],
  }

  exec { 'apply':
    command     => '/usr/sbin/dpkg-reconfigure -f noninteractive keyboard-configuration',
    subscribe   => Augeas['keyboard-layout'],
    require     => Augeas['keyboard-layout'],
    refreshonly => true
  } ->
  
  exec { 'apply-X':
    command     => '/sbin/udevadm trigger --subsystem-match=input --action=change',
    subscribe   => Augeas['keyboard-layout'],
    require     => Augeas['keyboard-layout'],
    refreshonly => true
  }
}
