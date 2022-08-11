# @summary Configure systemd exporter
#
class prometheus::client::systemd {
  include prometheus

  package { 'prometheus-systemd-exporter': }

  -> service { 'prometheus-systemd-exporter':
    ensure => running,
    enable => true,
  }

  Configvault_Write { 'prometheus/systemd':
    source => '/etc/identifier',
    public => true,
  }

  firewall { '100 allow prometheus systemd metrics':
    source => $prometheus::server_ip,
    dport  => 9558,
    proto  => 'tcp',
    action => 'accept',
  }
}
