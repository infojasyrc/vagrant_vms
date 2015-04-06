# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "symfony2app"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 80, host: 50100
  config.vm.network "private_network", ip: "10.10.0.34"
  config.vm.network "public_network", bridge: 'eth0'

  config.vm.provider "virtualbox" do |vb|
    vb.name = "symfony2app"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vbguest.auto_update = false

  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.bindfs.bind_folder "/vagrant", "/vagrant",
    :owner => "vagrant",
    :group => "www-data",
    :perms => "775"

  config.vm.provision "shell", path: "bash_files/bootstrap_lamp_for_symfony.sh"
end
