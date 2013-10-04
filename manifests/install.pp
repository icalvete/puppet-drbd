class drbd::install {

  package {$drbd::params::drbd_package:
    ensure => present,
  }

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
    
    }
    /^(CentOS|RedHat)$/: {
      package {$drbd::params::utils_package:
        ensure  => present,
        require => Package[$drbd::params::drbd_package]
      }
    }
    default: {
      fail("Operating system ${::operatingsystem} is not supported")
    }
  }

  # load kernel module
  exec { 'pre_load_drbd_kernel_module':
    command => 'depmod -a',
    path    => ['/bin/', '/sbin/'],
    unless  => 'grep -qe \'^drbd \' /proc/modules',
    require => Package[$drbd::params::drbd_package]
  }

  # ensure that the kernel module is loaded
  exec { 'load_drbd_kernel_module':
    command => 'modprobe drbd',
    path    => ['/bin/', '/sbin/'],
    unless  => 'grep -qe \'^drbd \' /proc/modules',
    require => Exec['pre_load_drbd_kernel_module']
  }
}
