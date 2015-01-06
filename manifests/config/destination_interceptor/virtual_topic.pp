define activemq::config::destination_interceptor::virtual_topic(
  $name = undef,
  $prefix = undef,
  $ensure = present
) {

  if $ensure in [ present, absent ] {
    $ensure_real = $ensure
  }
  else {
    fail("Activemq::Config::DestinationInterceptor::VirtualTopic[${title}]: parameter ensure must be present or absent")
  }

  case $ensure_real {
    'absent':
    {
      Augeas <| title == "virtual_topic/${title}/rm" |>
    }
    'present':
    {
      if (name == undef or prefix == undef) {
        fail("Activemq::Config::DestinationInterceptor::VirtualTopic[${title}]: parameters name and prefix must be defined")
      }

      Augeas <| title == "virtual_topic/${title}/rm" |>

      augeas { "virtual_topic/${title}/add" :
        lens    => 'Xml.lns',
        incl    => "/etc/activemq/activemq.xml",
        context => "/files/etc/activemq/activemq.xml/beans/broker",
        changes => [
          "set destinationInterceptors/virtualDestinationInterceptor/virtualDestinations/virtualTopic[last()+1]/#attribute/name ${name}",
          "set destinationInterceptors/virtualDestinationInterceptor/virtualDestinations/virtualTopic[last()]/#attribute/prefix ${prefix}",
        ],
        onlyif  => "match destinationInterceptors/virtualDestinationInterceptor/virtualDestinations/virtualTopic/#attribute/name[. =\"${name}\"] size == 0",
        require => Augeas["virtual_topic/${title}/rm"],
        notify  => Class['activemq::service']
      }
    }
    default: { notice('The given ensure parameter is not supported') }
  }

  @augeas { "virtual_topic/${title}/rm" :
    lens    => 'Xml.lns',
    incl    => "/etc/activemq/activemq.xml",
    context => "/files/etc/activemq/activemq.xml/beans/broker",
    changes => [
      "rm destinationInterceptors/virtualDestinationInterceptor/virtualDestinations/virtualTopic[.][#attribute/name = ${name}]",
    ],
    onlyif  => "match destinationInterceptors/virtualDestinationInterceptor/virtualDestinations/virtualTopic/#attribute/name[. =\"${name}\"] size > 0",
    require => File["/etc/activemq/activemq.xml"],
    notify  => Class['activemq::service']
  }

}