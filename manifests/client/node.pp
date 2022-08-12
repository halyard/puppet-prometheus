# @summary Configure node exporter
#
class prometheus::client::node {
  include prometheus

  package { 'prometheus-node-exporter': }

  -> file { '/etc/conf.d/prometheus-node-exporter':
    ensure  => file,
    content => 'NODE_EXPORTER_ARGS="--collector.textfile.directory=/var/lib/node-exporter"',
    notify  => Service['prometheus-node-exporter'],
  }

  -> file { '/var/lib/node-exporter':
    ensure => directory,
  }

  ~> service { 'prometheus-node-exporter':
    ensure => running,
    enable => true,
  }

  Configvault_Write { 'prometheus/node':
    source => '/etc/identifier',
    public => true,
  }

  firewall { '100 allow prometheus node metrics':
    source => $prometheus::server_ip,
    dport  => 9100,
    proto  => 'tcp',
    action => 'accept',
  }
}
