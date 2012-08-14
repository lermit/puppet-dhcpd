# Class: dhcpd::params
#
# This class defines default parameters used by the main module class dhcpd
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to dhcpd class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class dhcpd::params {

  ### DHCP related parameters
  $mode = 'standalone'
  $peer_port = 647
  $peer_address = ''

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'isc-dhcp-server',
    default                   => 'dhcp',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'isc-dhcp-server',
    default                   => 'dhcpd',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'dhcpd',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'root',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/dhcp',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/dhcp/dhcpd.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    default                   => '',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/dhcpd.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/dhcp',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/syslog',
  }

  $port = '67'
  $protocol = 'udp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = 'dhcpd/dhcpd.conf.erb'
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
