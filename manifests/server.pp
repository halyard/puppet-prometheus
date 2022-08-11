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
    content => template('prometheus/prometheus.yml.erb'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/servers_node.yml':
    ensure  => file,
    content => template('prometheus/servers_node.yml.erb'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/servers_wireguard.yml':
    ensure  => file,
    content => template('prometheus/servers_wireguard.yml.erb'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/servers_systemd.yml':
    ensure  => file,
    content => template('prometheus/servers_systemd.yml.erb'),
    require => Package['prometheus'],
    notify  => Service['prometheus'],
  }

  file { '/etc/prometheus/blackbox_http.yml':
    ensure  => file,
    content => template('prometheus/blackbox_http.yml.erb'),
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

  package { 'prometheus-blackbox-exporter': }

  -> file { '/etc/prometheus/blackbox.yml':
    ensure => file,
    source => 'puppet:///modules/prometheus/blackbox.yml',
  }

  ~> service { 'prometheus-blackbox-exporter':
    ensure => running,
    enable => true,
  }
}
