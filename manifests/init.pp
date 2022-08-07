# @summary Basic Prometheus settings
#
# @param server_ip is the IP address of the prometheus server
# @param address is how this server is reached
class prometheus (
  String $server_ip
  String $address = $facts['networking']['ip'],
) {
  file { '/etc/identifier':
    ensure  => file,
    content => $address,
  }
}
