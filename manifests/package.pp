class activemq::package(
  $package = undef,
  $version = undef,
  $versionlock = false
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')

  $version_real = $version

  $bool_versionlock = $versionlock ? {
    true  => 'present',
    false => 'absent',
  }

  # create activemq user and group
  # we might need the same uid and gid on different servers
  # if the activemq database resides on a NFS share
  group { 'activemq':
    ensure => 'present',
    gid    => '92',
  }
  user { 'activemq':
    ensure     => 'present',
    uid        => '92',
    gid        => '92',
    home       => '/usr/share/activemq',
    managehome => 'false',
    password   => '!!',
    shell      => '/bin/bash',
  }

  package { $package :
    ensure  => $version_real,
    require => User['activemq'],
  }


  case $::operatingsystemmajrelease {
    '8':{
      if $version_real =~ /(\d+\.\d+\.\d+)-(\d+.\w+.*)/ { # filter out version & release as capture groups
        yum::versionlock { $package:
          ensure  => $bool_versionlock,
          version => $1,
          release => $2,
          epoch   => 0,
        }
      }
    }
    default: {
      yum::versionlock { "0:${package}-${version}.*":
        ensure => $bool_versionlock
      }
    }
  }

}
