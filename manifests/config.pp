class activemq::config(
  $version = undef,
  $optional_config = undef,
  $advisorysupport = undef,
  $selectoraware = undef,
  $managementcontext_createconnector = undef,
  $transport_connector = undef,
  $data_dir = '/data/activemq',
  $users = undef,
  $destinations = undef,
  $sysconfig_options = undef,
  $persistence_db_driver_version = '6'
){

  $major_version_withoutrelease = regsubst($version, '^(\d+\.\d+)\.\d+-.*$','\1')
  notice("major_version_withoutrelease=${major_version_withoutrelease}")

  file { $data_dir:
    ensure => directory,
    owner  => 'activemq',
    group  => 'activemq'
  }

  file { "${data_dir}/heapdumps":
    ensure  => directory,
    owner   => 'activemq',
    group   => 'activemq',
    require => File['/data/activemq']
  }

  case $::osfamily {
    'RedHat': {
      if $::operatingsystemmajrelease < 7 {
        file { '/etc/init.d/activemq':
          ensure  => file,
          mode    => '0755',
          content => template("${module_name}/init/activemq"),
        }
      }
    }
  }

  file { '/etc/activemq':
    ensure => directory
  }

  file { '/etc/sysconfig/activemq':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq.sysconfig.erb"),
    notify  => Class['activemq::service']
  }

  file { '/etc/activemq/activemq.xml':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq.xml.erb"),
    replace => false,
    notify  => Class['activemq::service'],
    require => File['/etc/activemq']
  }

  file { '/etc/activemq/activemq-wrapper.conf':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq-wrapper.conf.erb"),
    notify  => Class['activemq::service']
  }

  file { '/etc/activemq/jetty-realm.properties':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/jetty-realm.properties.erb"),
    notify  => Class['activemq::service']
  }

  file { "/usr/share/activemq/lib/ojdbc${persistence_db_driver_version}.jar":
    ensure => file,
    source => "puppet:///modules/${module_name}/drivers/oracle/ojdbc${persistence_db_driver_version}.jar"
  }

  file { '/usr/share/activemq/lib/mysql-connector-java.jar':
    ensure => file,
    source => "puppet:///modules/${module_name}/drivers/mysql/mysql-connector-java-5.1.33.jar"
  }

}
