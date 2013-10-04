define drbd::resource::enable (

  $manage,
  $disk,
  $fs_type,
  $device,
  $ha_primary,
  $initial_setup,
  $cluster,
  $mountpoint,
  $automount,

) {

  if $manage {
    drbd::resource::up { $name:
      disk          => $disk,
      ha_primary    => $ha_primary,
      initial_setup => $initial_setup,
      fs_type       => $fs_type,
      device        => $device,
      mountpoint    => $mountpoint,
      automount     => $automount,
    }
  }
}
