include composer

# The `backend::essential` class install all required files for backend
class backend::essential {

  package { [
    'php5-common',
    'php5-dev',
    'php5-readline'
  ]:
    ensure => installed,
    before => Package['php-pear', 'php5-intl'],
  }

  package { [
    'php5-apcu',
    'php5-cli',
    'php5-fpm',
    'php5-gd',
    'php5-intl',
    'php5-json',
    'php5-memcache',
    'php5-xdebug'
  ]:
    ensure => installed,
    before => Package['php-pear'],
  }

  package { [
    'php5-mcrypt',
    'php5-curl',
    'php-pear'
  ]:
    ensure  => present,
    require => Class['system']
  }

  file { '/etc/php5/mods-available/xdebug.ini':
    source  => 'puppet:///modules/backend/xdebug.ini',
    owner   => 'root',
    group   => 'root',
    require => Package['php5-xdebug']
  }

}

# The `backend::packages` class installs composer and
# set permissions for composer folder
class backend::packages {

  class { 'composer':
    command_name => 'composer',
    target_dir   => '/usr/local/bin'
  }

  file { '/home/vagrant/.composer':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant'
  }

}

# The `backend::qa` installs code sniffer and mess detector
class backend::qa {

    exec { 'install php-code-sniffer':
        command => 'pear install --alldeps PHP_CodeSniffer',
        path    => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin'],
        creates => '/usr/bin/phpcs',
        require => Class['backend::essential'],
        before  => Exec['install php-depend', 'install php-mess-detector']
    }

    exec { 'install php-depend':
        command => 'pear channel-discover pear.pdepend.org && pear install --alldeps pdepend/PHP_Depend',
        path    => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin'],
        creates => '/usr/bin/pdepend',
        require => Class['backend::essential'],
        before  => Exec['install php-mess-detector']
  }

    exec { 'install php-mess-detector':
        command => 'pear channel-discover pear.phpmd.org && pear install --alldeps phpmd/PHP_PMD',
        path    => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin'],
        creates => '/usr/bin/phpmd',
        require => Exec['install php-depend']
    }

}


# The `backend` class run all dependencies
class backend {
    include backend::essential
    include backend::packages
    include backend::qa
}
