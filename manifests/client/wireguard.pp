# @summary Configure wireguard exporter
#
class prometheus::client::wireguard {
  include prometheus

  package { 'prometheus-wireguard-exporter': }

  -> file { '/etc/sudoers.d/prometheus-wireguard-exporter':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => 'wireguard_exporter ALL = NOPASSWD: /usr/bin/wg',
  }

  -> service { 'prometheus-wireguard-exporter':
    ensure => running,
    enable => true,
  }

  Configvault_Write { 'prometheus/wireguard':
    source => '/etc/identifier',
    public => true,
  }

  firewall { '100 allow prometheus wireguard metrics':
    source => $prometheus::server_ip,
    dport  => 9586,
    proto  => 'tcp',
    action => 'accept',
  }
}
