include mysql::server
include mysql::client
include mysql::bindings

class database {

  class { '::mysql::server':
    override_options        => {
      mysqld => { bind-address => '0.0.0.0' }
    },
    users                   => {
      'admin@%' => {
        ensure => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour     => '0',
        max_updates_per_hour     => '0',
        max_user_connections     => '0',
      },
      'admin@localhost' => {
        ensure => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour     => '0',
        max_updates_per_hour     => '0',
        max_user_connections     => '0',
      }
    },
    databases               => {
      'db_main' => {
        ensure  => present,
        charset => 'latin1',
        collate => 'latin1_swedish_ci'
      },
      'db_bk' => {
        ensure  => present,
        charset => 'latin1',
        collate => 'latin1_swedish_ci'
      }
    },
    grants                  => {
      'admin@%/db_main.*' => {
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'db_main.*',
        user       => 'admin@%',
      },
      'admin@localhost/db_main.*' => {
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'db_main.*',
        user       => 'admin@localhost',
      }
    }
  }

  class { '::mysql::client':
    require  => Class['::mysql::server']
  }

  class { '::mysql::bindings':
    php_enable         => true,
    php_package_ensure => 'present',
    require            => Class['::mysql::server']
  }

}
