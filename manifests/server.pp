# @summary Install Prometheus server
#
# @param hostname is the hostname for metrics reading
# @param tls_account is the account details for requesting the TLS cert
# @param grafana_password is the password for grafana to access metrics
# @param retention sets the retention window for local metrics
# @param static_targets is a hash of static_config targets
# @param tls_challengealias is the domain to use for TLS cert validation
# @param backup_target sets the target repo for backups
# @param backup_watchdog sets the watchdog URL to confirm backups are working
# @param backup_password sets the encryption key for backup snapshots
# @param backup_environment sets the env vars to use for backups
# @param backup_rclone sets the config for an rclone backend
class prometheus::server (
  String $hostname,
  String $tls_account,
  String $grafana_password,
  String $retention = '15d',
  Hash[String, Array[String]] $static_targets = {},
  Optional[String] $tls_challengealias = undef,
  Optional[String] $backup_target = undef,
  Optional[String] $backup_watchdog = undef,
  Optional[String] $backup_password = undef,
  Optional[Hash[String, String]] $backup_environment = undef,
  Optional[String] $backup_rclone = undef,
) {
  package { 'prometheus': }

  file { '/etc/conf.d/prometheus':
    ensure  => file,
    content => template('prometheus/conf.erb'),
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

  if $backup_target != '' {
    backup::repo { 'prometheus':
      source        => '/var/lib/prometheus',
      target        => $backup_target,
      watchdog_url  => $backup_watchdog,
      password      => $backup_password,
      environment   => $backup_environment,
      rclone_config => $backup_rclone,
    }
  }
}
