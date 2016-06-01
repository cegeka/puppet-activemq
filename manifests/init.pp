# Class: activemq
#
# This module manages activemq
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq(
  $package = 'activemq',
  $version = undef,
  $versionlock = false,
  $ensure = 'running',
  $data_dir = '/data/activemq',
  $data_dir_tmp = "${data_dir}/tmp",
  $scheduler_support_enabled = false,
  $persistence_adapter = 'kahadb',
  $persistence_db_type = 'derby',
  $persistence_db_driver_version = '6',
  $persistence_db_url = undef,
  $persistence_db_username = undef,
  $persistence_db_password = undef,
  $mqtt_enabled = false,
  $mqtt_ssl_enabled = false,
  $ssl_enabled = false,
  $ssl_keystore = undef,
  $ssl_keystore_password = undef,
  $ssl_keystore_key_password = undef,
  $ssl_truststore = undef,
  $ssl_truststore_password = undef,
  $webconsole = true,
  $webconsole_users = [
    { 'username' => 'admin',
      'password' => 'admin',
      'role'     => 'admin' },
    { 'username' => 'user',
      'password' => 'user',
      'role'     => 'user' }
  ],
  $jmx_enabled=false,
  $jmx_remote_port='1616',
  $jmx_remote_rmi_port='1617',
  $jmx_authentication_enabled=false,
  $heap_dump_path='/data/activemq/heapdumps',
  $tempUsage = '100 mb',
  $storeUsage = '1 gb',
  $memoryUsage = '20 mb',
  $topic_memoryLimit = '1mb',
  $queue_memoryLimit = '1mb',
  $advisorysupport = 'true',
  $selectoraware = true,
  $managementcontext_createconnector = 'false',
  $transport_connector = {},
  $users = {},
  $destinations = {},
  $sysconfig_options = {},
  $log4j_properties = {
    'log4j.rootLogger'                                => 'INFO, console',
    'log4j.logger.org.apache.activemq.spring'         => 'WARN',
    'log4j.logger.org.apache.activemq.web.handler'    => 'WARN',
    'log4j.logger.org.springframework'                => 'WARN',
    'log4j.logger.org.apache.xbean'                   => 'WARN',
    'log4j.logger.org.apache.camel'                   => 'INFO',
    'log4j.logger.org.eclipse.jetty'                  => 'WARN',
    'log4j.appender.console'                          => 'org.apache.log4j.ConsoleAppender',
    'log4j.appender.console.layout'                   => 'org.apache.log4j.PatternLayout',
    'log4j.appender.console.layout.ConversionPattern' => '%5p | %m%n',
    'log4j.appender.console.threshold'                => 'INFO',
    'log4j.appender.logfile'                          => 'org.apache.log4j.RollingFileAppender',
    'log4j.appender.logfile.file'                     => '\${activemq.base}/log/activemq.log',
    'log4j.appender.logfile.maxFileSize'              => '10240KB',
    'log4j.appender.logfile.maxBackupIndex'           => '10',
    'log4j.appender.logfile.append'                   => 'true',
    'log4j.appender.logfile.layout'                   => 'org.apache.log4j.PatternLayout',
    'log4j.appender.logfile.layout.ConversionPattern' => '%d | %-5p | %m | %c | %t%n',
    'log4j.throwableRenderer'                         => 'org.apache.log4j.EnhancedThrowableRenderer',
    'log4j.additivity.org.apache.activemq.audit'      => 'false',
    'log4j.logger.org.apache.activemq.audit'          => 'INFO, console',
    'log4j.appender.audit'                            => 'org.apache.log4j.RollingFileAppender',
    'log4j.appender.audit.file'                       => '\${activemq.base}/data/audit.log',
    'log4j.appender.audit.maxFileSize'                => '1024KB',
    'log4j.appender.audit.maxBackupIndex'             => '5',
    'log4j.appender.audit.append'                     => 'true',
    'log4j.appender.audit.layout'                     => 'org.apache.log4j.PatternLayout',
    'log4j.appender.audit.layout.ConversionPattern'   => '%-5p | %m | %t%n',
  },
  $optional_config = undef,
  $manage_config = false
) {

  include stdlib

  anchor { 'activemq::begin': }
  anchor { 'activemq::end': }

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_bool($versionlock)
  validate_re($ensure, '^running$|^stopped$')
  validate_re($persistence_adapter, '^kahadb$|^jdbc$')
  validate_re($persistence_db_type, '^derby$|^mysql$|^oracle$')
  validate_re($persistence_db_driver_version, '^6$|^7$')
  validate_re($advisorysupport, '^false$|^true$')
  validate_re($managementcontext_createconnector, '^false$|^true$')
  validate_bool($mqtt_enabled)
  validate_bool($mqtt_ssl_enabled)
  validate_bool($ssl_enabled)
  validate_bool($webconsole)
  validate_bool($scheduler_support_enabled)
  validate_bool($selectoraware)
  validate_bool($manage_config)
  validate_hash($transport_connector)
  validate_hash($users)
  validate_hash($destinations)
  validate_hash($sysconfig_options)
  validate_hash($log4j_properties)

  $version_real = $version
  $versionlock_real = $versionlock
  $ensure_real = $ensure
  $persistence_adapter_real = $persistence_adapter
  $persistence_db_type_real = $persistence_db_type
  $persistence_db_driver_version_real = $persistence_db_driver_version
  $mqtt_enabled_real = $mqtt_enabled
  $mqtt_ssl_enabled_real = $mqtt_ssl_enabled
  $scheduler_support_enabled_real = $scheduler_support_enabled
  $ssl_enabled_real = $ssl_enabled
  $webconsole_real = $webconsole
  $advisorysupport_real = $advisorysupport
  $selectoraware_real = $selectoraware
  $managementcontext_createconnector_real = $managementcontext_createconnector
  $transport_connector_real = $transport_connector
  $users_real = $users
  $destinations_real = $destinations
  $sysconfig_options_real = $sysconfig_options
  $log4j_properties_real = $log4j_properties
  $manage_config_real = $manage_config

  class { 'activemq::package':
    package     => $package,
    version     => $version_real,
    versionlock => $versionlock_real,
    notify      => Class['activemq::service']
  }

  class { 'activemq::config':
    version                           => $version_real,
    optional_config                   => $optional_config,
    data_dir                          => $data_dir,
    data_dir_tmp                      => $data_dir_tmp,
    persistence_db_driver_version     => $persistence_db_driver_version_real,
    advisorysupport                   => $advisorysupport_real,
    selectoraware                     => $selectoraware_real,
    managementcontext_createconnector => $managementcontext_createconnector_real,
    transport_connector               => $transport_connector_real,
    users                             => $users_real,
    destinations                      => $destinations_real,
    sysconfig_options                 => $sysconfig_options_real,
    log4j_properties                  => $log4j_properties_real,
    manage_config                     => $manage_config_real
  }

  class { 'activemq::service':
    ensure => $ensure_real
  }

  Anchor['activemq::begin'] -> Class['Activemq::Package']
    -> Class['Activemq::Config'] ~> Class['Activemq::Service'] -> Anchor['activemq::end']

}
