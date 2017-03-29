include apache

# The `app` class configure apache hosts
class app {

    apache::vhost { "${domain_name} non-ssl":
      servername      => "${domain_name}",
      port            => '80',
      ip              => '*',
      docroot         => '/vagrant/symfony/web',
      redirect_status => 'permanent',
      redirect_dest   => "https://${domain_name}/",
      docroot_owner   => 'vagrant',
      docroot_group   => 'www-data',
      error_log       => true,
      error_log_file  => 'backend-error.log',
      access_log      => true,
      access_log_file => '/var/log/apache2/backend-access.log',
      directories     => {
        path            => '/vagrant/symfony/web',
        options         => ['Indexes','FollowSymLinks','MultiViews'],
        allow_override  => ['All'],
      }
    }

    apache::vhost { "${domain_name} ssl":
      servername      => "${domain_name}",
      port            => '443',
      ip              => '*',
      docroot         => '/vagrant/symfony/web',
      ssl             => true,
      error_log       => true,
      error_log_file  => 'backend-ssl-error.log',
      access_log      => true,
      access_log_file => '/var/log/apache2/backend-ssl-access.log',
      directories     => {
        path            => '/vagrant/symfony/web',
        options         => ['Indexes','FollowSymLinks','MultiViews'],
        allow_override  => ['All'],
      }
    }

}
