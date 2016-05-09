# Introduction

Virtual development environment for a php (symfony) web application

# Requirements

- NFS
- Base Box: ubuntu/trusty64
- Vagrant
- VirtualBox
- Puppet

# Provision Files

## Using Puppet as Provisioner:

- Installing Vagrant and Puppet on OSX:

```
brew cask install vagrant
brew cask install puppet
```

- Installing Puppet on Ubuntu:

```
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get install -y puppet
```

# Vagrant Plugins required:

```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-bindfs
vagrant plugin install vagrant-hostmanager
```

- Installing Puppet modules: apache, mysql, nodejs, reboot and apt

```
puppet module install puppetlabs-apache
puppet module install puppetlabs-apt
puppet module install puppetlabs-mysql
puppet module install puppetlabs-nodejs
puppet module install puppetlabs-reboot
puppet module install willdurand-composer
```

# Additional information:

- Vagrant plugin for VirtualBox Guest Additions:

Source: https://github.com/dotless-de/vagrant-vbguest

- Vagrant plugin for BindFS (Binding file systems):

Source: https://github.com/gael-ian/vagrant-bindfs
