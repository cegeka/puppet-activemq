class activemq::package (
  $version = undef
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')

  $version_real = $version

  package { 'activemq':
    ensure  => $version_real
  }

  if $::osfamily == 'RedHat' {
    file { '/etc/init.d/activemq':
      ensure  => file,
      mode    => '0755',
      content => template("${module_name}/init/activemq"),
    }
  }
}
