include apache
include apache::mod::ssl

# The `webserver::install` install apache and default config files
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

# The `webserver` class run install class
class webserver {

  include webserver::install

}
