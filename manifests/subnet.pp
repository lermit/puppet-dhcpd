# = Define: dhcpd::subnet
#
# This class adds a subnetwork for DHCPD configuration
# This class also subscribes to @concat::fragment with tag specified by
# tag option. So, if you want to add a specific host configuration into this
# subnet just add the same tag as this subnet into dhcpd::host directive.
#
# == Parameters:
#
# [*ip*]
#   First subnet IP.
#   (Default: 192.168.0.0)
#
# [*netmask*]
#   Netmask
#   (Default: 255.255.255.0)
#
# [*range*]
#   Couples of start/ip address for range option.
#   (Default: { '192.168.0.10', '192.168.0.50' } )
#
# [*pxe_server*]
#   PXE server ip. Empty string mean no server.
#   (Default: '')
#
# [*pxe_file*]
#   PXE file to load. Empty string mean no file.
#   (Default: '')
#
# [*export_tag*]
#   Used tag for exported ressource
#   (Default: my-subnet)
#
# [*options*]
#   Subnet options
#   (Default: {})
#
# [*template*]
#   Header template used for subnet.
#   In order to permit host exported resource to be add to this file
#   we have to rebuild the subnet file each time. So we have two templates :
#   * The header
#   * The footer
#   Host exported resource will be add between each of them.
#   (Default: 'dhcpd/subnet.conf-header.erb')
#
# [*template_footer*]
#   Footer template used for subnet.
#   See [*template*] for more information.
#   (Default: 'dhcpd/subnet.conf-footer.erb')
#
# [*absent*]
#   Wathever we want to remove this subnet.
#   (Default: false)
#
# == Example:
#
# * Create a simple subnetwork
#   (192.168.0.0/24 with range 192.168.0.10 => 192.168.0.50)
#
#   class { 'dhcpd': }
#   dhcpd::subnet { 'my_subnet': }
#
# * With specific range
#   (192.168.0.10 => 192.168.0.50 and 192.168.0.75 => 192.168.0.100)
#
#   class { 'dhcpd': }
#   define::subnet { 'my_subnet':
#     range => {
#       '192.168.0.10' => '192.168.0.50',
#       '192.168.0.75' => '192.168.0.100',
#     },
#   }
#
# * Use specific options
#   (routers => 192.168.0.1)
#
#   class { 'dhcpd': }
#   dhcpd::subnet { 'my_subnet':
#     options => {
#       'routers' => '192.168.0.1',
#     },
#   }
#
define dhcpd::subnet(
  $ip              = '192.168.0.0',
  $netmask         = '255.255.255.0',
  $range           = {
        '192.168.0.10'  => '192.168.0.50',
    },
  $pxe_server      = '',
  $pxe_file        = '',
  $export_tag      = 'my-subnet',
  $options         = {},
  $template        = 'dhcpd/subnet.conf-header.erb',
  $template_footer = 'dhcpd/subnet.conf-footer.erb',
  $absent          = false) {

  $bool_absent = any2bool($absent)

  include dhcpd
  include concat::setup

  $subnet_config_file = "subnet-$ip.conf"

  if $bool_absent == false {
    concat { "$dhcpd::config_dir/$subnet_config_file":
      mode   => $dhcpd::config_file_mode,
      owner  => $dhcpd::config_file_owner,
      group  => $dhcpd::config_file_group,
      notify => $dhcpd::manage_service_autorestart,
    }

    # Register this subnet file into main configuration
    @@concat::fragment {"dhcpd-include-sudnet-$ip":
      target  => $dhcpd::config_file,
      content => template( 'dhcpd/include.erb' ),
      tag     => 'dhcpd.conf',
    }

    concat::fragment{"dhcpd-subnet-$ip-header":
      target  => "$dhcpd::config_dir/$subnet_config_file",
      content => template($template),
      order   => 01,
    }

    if $dhcpd::mode == 'master'
    or $dhcpd::mode == 'standalone' {
      Concat::Fragment <<| tag == "dhcpd-$export_tag" |>> {
        target => "$dhcpd::config_dir/$subnet_config_file",
        order  => 50,
      }
    }

    concat::fragment{"dhcpd-subnet-$ip-footer":
      target  => "$dhcpd::config_dir/$subnet_config_file",
      content => template($template_footer),
      order   => 99,
    }
  } else {
    file{"subnet-$name":
      ensure => absent,
      path   => "$dhcpd::config_dir/$subnet_config_file",
    }
  }
}
