class activemq::package(
  $package = undef,
  $version = undef,
  $versionlock = false
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')

  $version_real = $version

  # create activemq user and group
  # we might need the same uid and gid on different servers
  # if the activemq database resides on a NFS share
  group { 'activemq':
    ensure => 'present',
    gid    => '92',
  }
  user { 'activemq':
    ensure           => 'present',
    uid              => '92',
    gid              => '92',
    home             => '/usr/share/activemq',
    managehome       => 'false',
    password         => '!!',
    shell            => '/bin/bash',
  }

  package { $package :
    ensure  => $version_real,
    require => User['activemq'],
  }

  case $versionlock {
    true: {
      packagelock { $package : }
    }
    false: {
      packagelock { $package : ensure => absent }
    }
    default: { fail('Class[Activemq::Package]: parameter versionlock must be true or false') }
  }

}
