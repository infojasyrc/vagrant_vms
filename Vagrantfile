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

    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.manage_guest = true
        config.hostmanager.ignore_private_ip = false
        config.hostmanager.include_offline = true
    end

    config.vm.define "puppet" do |puppet|

        config.vm.provider "virtualbox" do |vb|
            vb.name = "#{configs['hostname']}"
            vb.memory = 2048
        end

        puppet.vm.box = "ubuntu/trusty64"
        puppet.vm.hostname = "#{configs['domain_name']}"
        puppet.vm.box_check_update = false

        ports.each do |key, value|
            puppet.vm.network "forwarded_port", guest: "#{value['guest']}", host: "#{value['host']}"
        end

        puppet.vm.network "private_network", ip: "#{configs['private_ip']}"
        #puppet.vm.network "public_network", bridge: vConfig['connection'], ip: vConfig['public_ip']
        puppet.hostmanager.aliases = %w(puppet)

        puppet.ssh.port = "#{ports['ssl']['host']}"

        if Vagrant.has_plugin?("vagrant-vbguest")
            puppet.vbguest.auto_update = false
        end

        puppet.vm.synced_folder ".", "/vagrant", :nfs => true

        if Vagrant.has_plugin?("vagrant-bindfs")
            puppet.bindfs.bind_folder "/vagrant", "/vagrant",
                :owner => "vagrant",
                :group => "www-data",
                :perms => "775"
        end

        puppet.vm.provision :puppet do |pu|
            pu.manifests_path = "provision/puppet/manifests"
            pu.manifest_file = "default.pp"
            pu.module_path = ["provision/puppet/modules","~/.puppet/modules"]
            pu.hiera_config_path = "provision/puppet/hiera.yaml"
            pu.facter = {
                "domain_name" => configs["domain_name"]
            }
            pu.options = ["--debug --trace --verbose --graph"]
        end

        # Bash Provision
        # config.vm.provision "shell", path: "bash_files/bootstrap_lamp_for_symfony.sh"
    end

end
