# @summary Configure node exporter
#
class prometheus::client::node {
  package { 'prometheus-node-exporter': }

  -> service { 'prometheus-node-exporter':
    ensure => running,
    enable => true,
  }

  Configvault_Write { "prometheus/node":
    source => '/etc/hostname',
    public => true
  }

  firewall { '100 allow prometheus node metrics':
    source => $prometheus::server_ip,
    dport  => 9100,
    proto  => 'tcp',
    action => 'accept',
  }
}
