class drbd::service {

  service { 'drbd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
