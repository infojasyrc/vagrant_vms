# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
configs     = YAML.load_file("#{current_dir}/config.yaml")
vConfig     = configs['configs'][configs['configs']['use']]
ports       = configs['ports']

# require additional plugins
unless Vagrant.has_plugin?("vagrant-bindfs")
  raise 'vagrant-bindfs is not installed! Type "vagrant plugin install vagrant-bindfs" to install.'
end

unless Vagrant.has_plugin?("vagrant-vbguest")
  raise 'vagrant-vbguest is not installed! Type "vagrant plugin install vagrant-vbguest" to install.'
end

unless Vagrant.has_plugin?("vagrant-hostmanager")
  raise 'vagrant-hostmanager is not installed! Type "vagrant plugin install vagrant-hostmanager" to install.'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "#{configs['hostname']}"
    config.vm.box_check_update = true

    ports.each do |key, value|
        config.vm.network "forwarded_port", guest: "#{value['guest']}", host: "#{value['host']}"
    end

    config.vm.network "private_network", type: "dhcp"
    config.vm.network "public_network", bridge: vConfig['connection'], ip: vConfig['public_ip']

    config.ssh.port = "#{ports['ssl']['host']}"

    config.vm.provider "virtualbox" do |vb|
        vb.name = "#{configs['hostname']}"
        vb.memory = 2048
    end

    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.manage_guest = true
        config.hostmanager.ignore_private_ip = false
        config.hostmanager.include_offline = true
        config.hostmanager.aliases = %w(app.example.com)

        config.vm.provision :hostmanager
    end

    if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = false
    end

    config.vm.synced_folder ".", "/vagrant", :nfs => true

    if Vagrant.has_plugin?("vagrant-bindfs")
        config.bindfs.bind_folder "/vagrant", "/vagrant",
            :owner => "vagrant",
            :group => "www-data",
            :perms => "775"
    end

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "provision/puppet/manifests"
        puppet.manifest_file = "default.pp"
        puppet.module_path = ["provision/puppet/modules","~/.puppet/modules"]
        puppet.hiera_config_path = "provision/puppet/hiera.yaml"
        puppet.facter = {
            "domain_name" => configs["domain_name"]
        }
        puppet.options = ["--debug --trace --verbose --graph"]
    end

    #Bash Provision
    # config.vm.provision "shell", path: "bash_files/bootstrap_lamp_for_symfony.sh"

end
