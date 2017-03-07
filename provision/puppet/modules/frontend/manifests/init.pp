include nodejs

class frontend::essential {

    class { '::nodejs':
        manage_package_repo       => false,
        repo_url_suffix           => '4.x',
        nodejs_dev_package_ensure => 'present',
        npm_package_ensure        => 'present',
    }

    package { 'bower':
        ensure   => 'present',
        provider => 'npm',
        require  => Class['nodejs']
    }

    package { 'grunt-cli':
        ensure   => 'present',
        provider => 'npm',
        require  => Class['nodejs']
    }

}

class frontend::link {

  file { '/usr/bin/node':
    ensure  => 'link',
    target  => '/usr/bin/nodejs',
    force   => true,
    require => Class['frontend::essential']
  }

}

class frontend {
    include frontend::essential
    include frontend::link
}
