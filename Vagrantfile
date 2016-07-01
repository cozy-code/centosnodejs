Vagrant.configure("2") do |config|
  config.vm.box = "CentOS65"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  config.vm.synced_folder "src/", "/home/vagrant/src"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Provider-specific configuration so you can fine-tune various
  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell",  privileged: true,  path: "base.sh"
  config.vm.provision "shell",  privileged: false, path: "node_env.sh"
  config.vm.provision "shell",  privileged: true,  path: "mongodb_env.sh"
  config.vm.provision "shell",  privileged: true,  path: "php_env.sh"

end
