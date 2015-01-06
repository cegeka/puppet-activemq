class activemq::preconfig {

  file { '/etc/activemq':
    ensure => directory
  }

  file { '/etc/activemq/activemq.xml':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/activemq.xml.erb"),
    replace => false,
    notify  => Class['activemq::service'],
    require => File['/etc/activemq']
  }

}
