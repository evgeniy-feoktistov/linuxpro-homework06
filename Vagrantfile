# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
	config.vm.box = "centos/7"
	config.vm.box_version = "2004.01"
	config.vm.provider "virtualbox" do |v|
	v.memory = 256
	v.cpus = 1
	end
	config.vm.define "pack" do |pack|
	pack.vm.hostname = "pack"
	pack.vm.provision "shell", path: "pack_script.sh"
	end
end
