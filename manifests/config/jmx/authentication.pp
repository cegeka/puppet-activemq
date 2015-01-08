define activemq::config::jmx::authentication($jmx_username, $jmx_password, $jmx_access) {

  file { "/etc/activemq/jmxremote.password":
    ensure  => file,
    content => template("${module_name}/conf/jmxremote.password.erb"),
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0600',
    require => Class['activemq::package']
  }

  file { "/etc/activemq/jmxremote.access":
    ensure  => file,
    content => template("${module_name}/conf/jmxremote.access.erb"),
    owner   => 'activemq',
    group   => 'activemq',
    mode    => '0600',
    require => Class['activemq::package']
  }

}
