class activemq::service(
  $ensure = 'running'
) {

  $v_ensure = [ '^running$', '^stopped$' ]
  validate_re($ensure, $v_ensure)

  $ensure_real = $ensure

  service { 'activemq':
    ensure     => $ensure_real,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::package'],
  }

}
