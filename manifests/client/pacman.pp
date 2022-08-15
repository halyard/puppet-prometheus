# @summary Configure pacman textfile exporter
#
class prometheus::client::pacman {
  include prometheus::client::textfile

  file { '/usr/local/bin/node-exporter-pacman.sh':
    ensure => file,
    source => 'puppet:///modules/prometheus/node-exporter-pacman.sh',
    mode   => '0755',
  }

  service { 'node-exporter@pacman.timer':
    ensure => running,
    enable => true,
  }
}
