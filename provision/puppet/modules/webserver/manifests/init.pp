include apache
include apache::mod::ssl

class webserver::install {

  class { 'apache':
    default_mods        => true,
    default_confd_files => true,
    default_vhost       => true,
    default_ssl_vhost   => true,
    mpm_module          => 'prefork'
  }

  apache::mod { 'rewrite': }
  apache::mod { 'actions': }
  apache::mod { 'fastcgi': }

  class { 'apache::mod::ssl':
    ssl_compression => true,
  }

  class { '::apache::mod::php': }

}

class webserver {

  include webserver::install

}
