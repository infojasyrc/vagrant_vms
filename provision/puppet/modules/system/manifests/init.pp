include apt

Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

class system::sources {

  class { 'apt':
    purge  => {
      'sources.list'  => false,
      'source.list.d' => false,
      'preferences'   => false,
      'preferences.d' => false
    },
    update => {
      'frequency' => 'always',
      'timeout'   => undef
    }
  }

  apt::source { 'ubuntu_trusty':
    location => 'http://archive.ubuntu.com/ubuntu/',
    release  => 'trusty',
    repos    => 'main restricted universe multiverse',
  }

  apt::source { 'ubuntu_trusty-updates':
    location => 'http://archive.ubuntu.com/ubuntu/',
    release  => 'trusty-updates',
    repos    => 'main restricted universe multiverse',
  }

  apt::source { 'ubuntu_trusty-security':
    location => 'http://archive.ubuntu.com/ubuntu/',
    release  => 'trusty-security',
    repos    => 'main restricted universe multiverse',
  }

  ::apt::ppa { 'ppa:git-core/ppa': }

}

class system::utilities {

  package { [
      'python-software-properties',
      'build-essential',
      'vim'
    ]:
    ensure => installed,
    before => Package['bindfs', 'mcrypt', 'curl', 'libmagickwand-dev']
  }

  package { 'bindfs':
    ensure => present,
    notify => Reboot['after_run'],
    before => Package['mcrypt', 'curl', 'libmagickwand-dev']
  }

  reboot { 'after_run':
    apply  => finished,
  }

  package { [
    'curl',
    'mcrypt',
    'libmagickwand-dev'
  ]:
    ensure => present
  }

  package { [
    'git-core',
    'git'
  ]:
    ensure  => present,
    require => Class['system::sources']
  }

}

class system {

  include system::sources
  include system::utilities

}
