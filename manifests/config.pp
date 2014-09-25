class activemq::config {

  file { '/data/activemq':
    ensure => directory
  }

  file { '/etc/activemq/activemq.xml':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/activemq.xml.erb"),
    notify  => Class['activemq::service']
  }

  file { '/etc/activemq/jetty-realm.properties':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/jetty-realm.properties.erb"),
    notify  => Class['activemq::service']
  }

  file { '/etc/activemq/jetty.xml':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/jetty.xml.erb"),
    notify  => Class['activemq::service']
  }

  file { '/etc/activemq/log4j.properties':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/log4j.properties.erb"),
    notify  => Class['activemq::service']
  }

}
