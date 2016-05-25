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
  $optional_config = undef,
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
  validate_bool($mqtt_enabled)
  validate_bool($mqtt_ssl_enabled)
  validate_bool($ssl_enabled)
  validate_bool($webconsole)
  validate_bool($scheduler_support_enabled)

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

  class { 'activemq::preconfig':
    version     => $version_real,
    optional_config => $optional_config
  }

  class { 'activemq::package':
    package     => $package,
    version     => $version_real,
    versionlock => $versionlock_real,
    notify      => Class['activemq::service']
  }

  class { 'activemq::config':
    version                       => $version_real,
    persistence_db_driver_version => $persistence_db_driver_version_real
  }

  class { 'activemq::service':
    ensure => $ensure_real
  }

  Anchor['activemq::begin'] -> Class['Activemq::Preconfig'] -> Class['Activemq::Package']
    -> Class['Activemq::Config'] ~> Class['Activemq::Service'] -> Anchor['activemq::end']

}
