#puppet-drbd

Puppet manifest to install and configure drbd.

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-drbd.png)](http://travis-ci.org/icalvete/puppet-brbd)

At this time, ubuntu 12.04 have a [bug](https://bugs.launchpad.net/ubuntu/+source/drbd8/+bug/1103656) 

##Actions:

* Works in Debian|Ubuntu|RedHat|CentOS

##Requires:

* https://github.com/icalvete/puppet-common


##Example:

    node 'centos01.smartpurposes.net' inherits sp_defaults {
      include roles::puppet_agent
      
      drbd::resource { 'test':
        host1         => 'centos01',
	host2         => 'centos02',
	ip1           => '192.168.10.60',
	ip2           => '192.168.10.61',
	disk          => '/dev/sdb',
	port          => '7789',
	device        => '/dev/drbd0',
	manage        => true,
	verify_alg    => 'sha1',
	ha_primary    => true,
	initial_setup => true,
	mountpoint    => '/test',
	automount     => true,
      }
    }

    node 'centos02.smartpurposes.net' inherits sp_defaults {
      include roles::puppet_agent
      
      drbd::resource { 'test':
        host1         => 'centos01',
	host2         => 'centos02',
	ip1           => '192.168.10.60',
	ip2           => '192.168.10.61',
	disk          => '/dev/sdb',
	port          => '7789',
	device        => '/dev/drbd0',
	manage        => true,
	verify_alg    => 'sha1',
	ha_primary    => false,
	initial_setup => false,
	mountpoint    => '/test',
	automount     => true,
      }
    }


##Authors:

Israel Calvete Talavera <icalvete@gmail.com>
