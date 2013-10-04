class drbd::params {

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      $drbd_package = 'drbd8-utils'
    }
    /^(CentOS|RedHat)$/: {
      $utils_package   = 'drbd84-utils'
      $drbd_package = 'kmod-drbd84'
    }
    default: {
      fail("Operating system ${::operatingsystem} is not supported")
    }
  }
}

