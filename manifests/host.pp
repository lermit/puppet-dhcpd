# = Define: dhcpd::host
#
# This class add a host difinition into configured subnet.
# Please be award to set correct correctly tag option in
# order to have your host bind to desired subnet.
#
# == Parameters:
#
# [*hwaddr*]
#   Mac address of host
#   This parameter is mandatory
#
# [*ip*]
#   Desired IP
#   (Default : '')
#
# [*export_tag*]
#   Used tag for exported ressource.
#   Set the same export_tag as desired subnet.
#   (Default: my-subnet)
#
# [*options*]
#   host options
#   (Default: {})
#
# [*template*]
#   Template used for host definition.
#   (Default: 'dhcpd/host.erb')
#
# [*pxe_server*]
#   PXE server ip if we want one to this host.
#   (Default: '')
#
# [*pxe_file*]
#   PXE file for host if we want one.
#   (Default: '')
#
# [*absent*]
#   Either we want to remove this subnet.
#   (Default: false)
#
# == Example:
#
# * Define simple host
#
#   dhcpd::host { 'me':
#     hwaddr => 'D5-7B-CE-4F-A7-41',
#     ip     => '192.168.0.42',
#   }
#
# * Define simple host with specific PXE server + file
#   dhcpd::host { 'me':
#     hwaddr     => 'D5-7B-CE-4F-A7-41',
#     ip         => '192.168.0.42',
#     pxe_server => '192.168.0.2',
#     pxe_file   => 'pxelinux.0',
#   }
#
define dhcpd::host(
  $hwaddr,
  $ip              = '',
  $export_tag      = 'my-subnet',
  $options         = {},
  $template        = 'dhcpd/host.erb',
  $pxe_server      = '',
  $pxe_file        = '',
  $absent          = false) {

  $bool_absent = any2bool($absent)

  if $bool_absent == false {
    @@concat::fragment{"dhcpd-host-$name":
      content => template($template),
      tag     => "dhcpd-$export_tag",
    }
  }


}
