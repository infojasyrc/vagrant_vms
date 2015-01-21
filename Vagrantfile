# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "lab04"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 80, host: 8088
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "public_network", bridge: 'en4: Thunderbolt Ethernet'

  config.vm.provider "virtualbox" do |vb|
    vb.name = "sf2-lab04"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vbguest.auto_update = false

  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.bindfs.bind_folder "/vagrant", "/vagrant",
    :owner => "vagrant",
    :group => "www-data",
    :perms => "775"

  config.vm.provision "shell", path: "setup.sh"
end
