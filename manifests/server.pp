# @summary Install Prometheus server
#
# @param hostname is the hostname for metrics reading
# @param tls_account is the account details for requesting the TLS cert
# @param grafana_password is the password for grafana to access metrics
# @param tls_challengealias is the domain to use for TLS cert validation
class prometheus::server (
  String $hostname,
  String $tls_account,
  String $grafana_password,
  Optional[String] $tls_challengealias = undef,
) {
  package { 'prometheus': }

  file { '/etc/conf.d/prometheus':
    ensure  => file,
    source  => 'puppet:///modules/prometheus/conf',
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/prometheus.yml':
    ensure  => file,
    content => template('prometheus/prometheus.yml'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/servers_node.yml':
    ensure  => file,
    content => template('prometheus/servers_node.yml'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/servers_wireguard.yml':
    ensure  => file,
    content => template('prometheus/servers_wireguard.yml'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  service { 'prometheus':
    ensure => running,
    enable => true,
  }

  nginx::site { $hostname:
    proxy_target       => 'http://localhost:9090',
    tls_challengealias => $tls_challengealias,
    tls_account        => $tls_account,
    users              => {
      'grafana'  => $grafana_password,
    },
  }
}
