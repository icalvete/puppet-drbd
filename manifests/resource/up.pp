define drbd::resource::up (

  $disk,
  $ha_primary,
  $initial_setup,
  $fs_type,
  $device,
  $mountpoint,
  $automount,

) {

  # create metadata on device, except if resource seems already initalized.
  # drbd is very tenacious about asking for aproval if there is data on the
  # volume already.
  exec { "initialize DRBD metadata for ${name}":
    command => "yes yes | /sbin/drbdadm create-md ${name}",
    onlyif  => "/usr/bin/test -e ${disk}",
    unless  => "/sbin/drbdadm cstate ${name} | /bin/egrep -q '^(Sync|Connected|WFConnection|StandAlone)'",
    before  => Class['drbd::service'],
    require => Class['drbd::install'],
    notify  => Class['drbd::service']
  }

  exec { "enable DRBD resource ${name}":
    command => "/sbin/drbdadm up ${name}",
    onlyif  => "/sbin/drbdadm dstate ${name} | /bin/egrep -q '^(Diskless/|Unconfigured|Consistent)'",
    before  => Class['drbd::service'],
    require => Exec["initialize DRBD metadata for ${name}"],
    notify  => Class['drbd::service']
  }

  # these resources should only be applied if we are configuring the
  # primary node in our HA setup
  if $ha_primary {

    # these things should only be done on the primary during initial setup
    if $initial_setup {

      exec { "drbd_make_primary_${name}":
        command => "/sbin/drbdadm --force primary ${name}",
        unless  => "/sbin/drbdadm role ${name} | /bin/egrep '^Primary'",
        onlyif  => "/sbin/drbdadm dstate ${name} | /bin/egrep '^Inconsistent'",
        notify  => Exec["drbd_format_volume_${name}"],
        before  => Exec["drbd_make_primary_again_${name}"],
        require => Class['drbd::service']
      }

      exec { "drbd_format_volume_${name}":
        command     => "/sbin/mkfs.${fs_type} ${device}",
        refreshonly => true,
        require     => Exec["drbd_make_primary_${name}"],
        before      => $automount ? {
          false   => undef,
          default => Mount[$mountpoint],
        },
      }
    }

    exec { "drbd_make_primary_again_${name}":
      command => "/sbin/drbdadm primary ${name}",
      unless  => "/sbin/drbdadm role ${name} | /bin/egrep '^Primary'",
      require => Class['drbd::service'],
    }

    if $automount {

      if ! $mountpoint {

        fail('mounpoint is needed by automount.')

      }else{

        exec{"create_drbd_${mountpoint}":
          command => "mkdir -p ${mountpoint}",
          unless  => "test -d ${mountpoint}",
        }
      }

      # ensure that the device is mounted
      mount { "mount_drbd_${mountpoint}":
        ensure  => mounted,
        name    => $mountpoint,
        atboot  => false,
        device  => $device,
        fstype  => 'auto',
        options => 'defaults,noauto',
        require => [
          Exec["drbd_make_primary_again_${name}"],
          File[$mountpoint],
          Class['drbd::service'],
          Exec["create_drbd_${mountpoint}"]
          ],
      }
    }
  }
}
