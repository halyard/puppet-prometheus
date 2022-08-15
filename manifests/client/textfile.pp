# @summary Configure textfile exporter services
#
class prometheus::client::textfile {
  include prometheus::client::node

  file { '/etc/systemd/system/node-exporter@.service':
    ensure => 'file',
    source => 'puppet:///modules/prometheus/node-exporter@.service',
  }

  file { '/etc/systemd/system/node-exporter@.timer':
    ensure => 'file',
    source => 'puppet:///modules/prometheus/node-exporter@.timer',
  }
}
