class activemq::preconfig (
  $optional_config = undef,
  $version = undef,
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')

  $version_real = $version

  file { '/etc/activemq':
    ensure => directory
  }

  file { '/etc/activemq/activemq.xml':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/${version_real}/activemq.xml.erb"),
    replace => false,
    notify  => Class['activemq::service'],
    require => File['/etc/activemq']
  }

}
