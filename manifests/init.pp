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
  $version = 'present',
  $ensure = 'running',
  $data_dir = '/data/activemq',
  $persistence_adapter = 'kahaDB',
  $webconsole = true
) {

  include stdlib

  anchor { 'activemq::begin': }
  anchor { 'activemq::end': }

  validate_re($ensure, '^running$|^stopped$')
  validate_re($version, '^present$|^latest$|^[~+._0-9a-zA-Z:-]+$')
  validate_bool($webconsole)
  validate_re($persistence_adapter, '^kahaDB$|^jdbc$')

  $version_real = $version
  $ensure_real = $ensure
  $webconsole_real = $webconsole
  $persistence_adapter_real = $persistence_adapter

  class { 'activemq::package':
    version => $version_real,
    notify  => Class['activemq::service'],
  }

  class { 'activemq::config': }

  class { 'activemq::service':
    ensure => $ensure_real
  }

  Anchor['activemq::begin'] -> Class['Activemq::Package'] -> Class['Activemq::Config'] ~> Class['Activemq::Service'] -> Anchor['activemq::end']

}
