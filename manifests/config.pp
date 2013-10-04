class drbd::config {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/drbd':
    ensure => directory,
  }

  file { '/etc/drbd.conf':
    source => "puppet:///modules/${module_name}/drbd.conf",
  }

  file { '/etc/drbd.d/global_common.conf':
    content => template("${module_name}/global_common.conf.erb")
  }

  file { '/etc/drbd.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
    mode    => '0644',
  }
}
