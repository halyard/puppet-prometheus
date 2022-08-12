# @summary Configure pacman textfile exporter
#
class prometheus::client::pacman {
  include prometheus::client::node

  package { 'pacman-contrib': }

  file { '/usr/local/bin/node-exporter-pacman.sh':
    ensure => file,
    source => 'puppet:///modules/prometheus/node-exporter-pacman.sh',
    mode   => '0755',
    notify => Service['node-exporter-pacman.timer'],
  }

  file { '/etc/systemd/system/node-exporter-pacman.service':
    ensure => 'file',
    source => 'puppet:///modules/prometheus/node-exporter-pacman.service',
    notify => Service['node-exporter-pacman.timer'],
  }

  file { '/etc/systemd/system/node-exporter-pacman.timer':
    ensure => 'file',
    source => 'puppet:///modules/prometheus/node-exporter-pacman.timer',
    notify => Service['node-exporter-pacman.timer'],
  }

  service { 'node-exporter-pacman.timer':
    ensure => running,
    enable => true,
  }
}
