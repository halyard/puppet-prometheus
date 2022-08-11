# @summary Configure blackbox exporter
#
# @param http_urls sets the sites to check with the http blackbox probe
class prometheus::client::blackbox (
  Array[String] $http_urls = []
) {
  include prometheus

  file { '/etc/blackbox_http':
    ensure  => file,
    content => $http_urls.join("\n"),
  }

  -> Configvault_Write { 'prometheus/blackbox/http':
    source => '/etc/blackbox_http',
    public => true,
  }
}
