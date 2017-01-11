class activemq::config(
  $version = undef,
  $optional_config = undef,
  $advisorysupport = undef,
  $selectoraware = undef,
  $managementcontext_createconnector = undef,
  $transport_connector = undef,
  $data_dir = undef,
  $data_dir_tmp = undef,
  $users = undef,
  $destinations = undef,
  $sysconfig_options = undef,
  $log4j_properties = undef,
  $persistence_db_driver_version = undef,
  $manage_config = undef
){

  $major_version_withoutrelease = regsubst($version, '^(\d+\.\d+)\.\d+-.*$','\1')

  file { $data_dir:
    ensure => directory,
    owner  => 'activemq',
    group  => 'activemq'
  }

  file { $data_dir_tmp:
    ensure => directory,
    owner  => 'activemq',
    group  => 'activemq'
  }

  file { "${data_dir}/heapdumps":
    ensure => directory,
    owner  => 'activemq',
    group  => 'activemq',
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
    default: { notice('Only Redhat is supported') }
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

  file { '/etc/activemq/log4j.properties':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/log4j.properties.erb"),
    notify  => Class['activemq::service'],
    require => File['/etc/activemq']
  }

  file { '/etc/activemq/activemq.xml':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq.xml.erb"),
    replace => $manage_config,
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
