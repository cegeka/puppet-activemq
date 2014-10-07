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
  $version = undef,
  $versionlock = false,
  $ensure = 'running',
  $data_dir = '/data/activemq',
  $persistence_adapter = 'kahadb',
  $persistence_db_type = 'derby',
  $persistence_db_driver_version = '6',
  $persistence_db_url = undef,
  $persistence_db_username = undef,
  $persistence_db_password = undef,
  $webconsole = true
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
  validate_bool($webconsole)

  $version_real = $version
  $versionlock_real = $versionlock
  $ensure_real = $ensure
  $webconsole_real = $webconsole
  $persistence_adapter_real = $persistence_adapter
  $persistence_db_type_real = $persistence_db_type
  $persistence_db_driver_version_real = $persistence_db_driver_version

  class { 'activemq::package':
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

  Anchor['activemq::begin'] -> Class['Activemq::Package'] -> Class['Activemq::Config'] ~> Class['Activemq::Service'] -> Anchor['activemq::end']

}
