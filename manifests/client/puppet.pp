# @summary Configure puppet textfile exporter
#
class prometheus::client::puppet {
  include prometheus::client::textfile

  file { '/usr/local/bin/node-exporter-puppet.sh':
    ensure => file,
    source => 'puppet:///modules/prometheus/node-exporter-puppet.sh',
    mode   => '0755',
  }

  service { 'node-exporter@puppet.timer':
    ensure => running,
    enable => true,
  }
}
