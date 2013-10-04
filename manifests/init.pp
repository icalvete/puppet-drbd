class drbd inherits params {

  anchor{'drbd::begin':
    before => Class['drbd::install']
  }

  class{'drbd::install':
    require => Anchor['drbd::begin']
  }

  class{'drbd::config':
    require => Class['drbd::install'],
    notify  => Class['drbd::service']
  }

  class{'drbd::service':
    require => Class['drbd::config']
  }

  anchor{'drbd::end':
    require => Class['drbd::service']
  }
}
