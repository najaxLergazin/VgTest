
Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.56.100"

  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder "./www", "/var/www"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  config.vm.provision "shell", path: "provision.sh"
  
end
