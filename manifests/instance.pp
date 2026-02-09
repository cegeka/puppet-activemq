define activemq::instance(
  $package = undef,
  $version = undef,
  $versionlock = false,
  $identifier = undef,
  $service_limits = false,
  $data_dir = $activemq::data_dir,
  $data_dir_tmp = $activemq::data_dir_tmp,
  $scheduler_support_enabled = $activemq::scheduler_support_enabled,
  $persistence_adapter = $activemq::persistence_adapter,
  $persistence_db_type = $activemq::persistence_db_type,
  $persistence_db_driver_version = $activemq::persistence_db_driver_version,
  $persistence_db_url = $activemq::persistence_db_url,
  $persistence_db_username = $activemq::persistence_db_username,
  $persistence_db_password = $activemq::persistence_db_password,
  $mqtt_enabled = $activemq::mqtt_enabled,
  $mqtt_ssl_enabled = $activemq::mqtt_ssl_enabled,
  $ssl_enabled = $activemq::ssl_enabled,
  $ssl_keystore = $activemq::ssl_keystore,
  $ssl_keystore_password = $activemq::ssl_keystore_password,
  $ssl_keystore_key_password = $activemq::ssl_keystore_key_password,
  $ssl_truststore = $activemq::ssl_truststore,
  $ssl_truststore_password = $activemq::ssl_truststore_password,
  $webconsole = $activemq::webconsole,
  $manage_webusers = $activemq::manage_webusers,
  $webconsole_users = $activemq::webconsole_users,
  $jmx_enabled = $activemq::jmx_enabled,
  $jmx_remote_port = $activemq::jmx_remote_port,
  $jmx_remote_rmi_port = $activemq::jmx_remote_rmi_port,
  $jmx_authentication_enabled = $activemq::jmx_authentication_enabled,
  $heap_dump_path = $activemq::heap_dump_path,
  $tempUsage = $activemq::tempUsage,
  $storeUsage = $activemq::storeUsage,
  $memoryUsage = $activemq::memoryUsage,
  $topic_memoryLimit = $activemq::topic_memoryLimit,
  $queue_memoryLimit = $activemq::queue_memoryLimit,
  $advisorysupport = $activemq::advisorysupport,
  $selectoraware = $activemq::selectoraware,
  $managementcontext_createconnector = $activemq::managementcontext_createconnector,
  $transport_connector = $activemq::transport_connector,
  $users = $activemq::users,
  $destinations = $activemq::destinations,
  $sysconfig_options = $activemq::sysconfig_options,
  $log4j_properties = $activemq::log4j_properties,
  $log4j2_properties = $activemq::log4j2_properties,
  $optional_config = $activemq::optional_config,
  $manage_config = $activemq::manage_config,

) {

  $major_version_withoutrelease = regsubst($version, '^(\d+\.\d+)\.\d+-.*$','\1')

  if $identifier != undef {
    $id = $identifier
  } else {
    $id = regsubst($major_version_withoutrelease, '\.', '')
  }

  package { $package :
    ensure  => $version
  }

  file { "/var/run/activemq${id}":
    ensure => directory,
    owner  => 'activemq',
    group  => 'activemq'
  }

  file { "/etc/sysconfig/activemq${id}":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq.sysconfig.erb")
  }

  if empty($log4j2_properties) {
    file { "/etc/activemq${id}/log4j.properties":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/v${major_version_withoutrelease}/log4j.properties.erb")
    }
  } else {
    file { "/etc/activemq${id}/log4j2.properties":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/v${major_version_withoutrelease}/log4j2.properties.erb")
    }
  }

  file { "/etc/activemq${id}/activemq.xml":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq.xml.erb"),
    replace => $manage_config
  }

  file { "/etc/activemq${id}/activemq-wrapper.conf":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/v${major_version_withoutrelease}/activemq-wrapper.conf.erb")
  }

  if ($manage_webusers) {
    file { "/etc/activemq${id}/jetty-realm.properties":
      ensure  => file,
      mode    => '0644',
      content => template("${module_name}/jetty-realm.properties.erb")
    }
  }

  file { "/usr/share/activemq${id}/lib/ojdbc${persistence_db_driver_version}.jar":
    ensure => file,
    source => "puppet:///modules/${module_name}/drivers/oracle/ojdbc${persistence_db_driver_version}.jar"
  }

  file { "/usr/share/activemq${id}/lib/mysql-connector-java.jar":
    ensure => file,
    source => "puppet:///modules/${module_name}/drivers/mysql/mysql-connector-java-5.1.33.jar"
  }

  if $service_limits {

    file { "/etc/systemd/system/activemq${id}.service.d":
      ensure => link,
      target  => "/etc/systemd/system/activemq.service.d"
    }

  }

}
