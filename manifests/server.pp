# @summary Install Prometheus server
#
class prometheus::server {
  package { 'prometheus': }

  -> service { 'prometheus':
    ensure => running,
    enable => true,
  }
}
