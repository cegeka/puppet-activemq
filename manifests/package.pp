class activemq::package(
  $package = undef,
  $version = undef,
  $versionlock = false
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')

  $version_real = $version

  package { $package :
    ensure  => $version_real
  }

  case $versionlock {
    true: {
      packagelock { 'activemq': }
    }
    false: {
      packagelock { 'activemq': ensure => absent }
    }
    default: { fail('Class[Activemq::Package]: parameter versionlock must be true or false') }
  }

  if $::osfamily == 'RedHat' {
    file { '/etc/init.d/activemq':
      ensure  => file,
      mode    => '0755',
      content => template("${module_name}/init/activemq"),
    }
  }

}
