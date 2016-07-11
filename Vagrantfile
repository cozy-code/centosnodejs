Vagrant.configure("2") do |config|
  config.vm.box = "CentOS65"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  config.vm.synced_folder "provision/", "/home/vagrant/provision"
  #https://github.com/gulpjs/gulp/issues/448
  # Mac ~$ sudo nfsd status
  # nfsd service is enabled
  config.vm.synced_folder "src/", "/home/vagrant/src", :nfs => true,:mount_options => ['actimeo=2']
  config.vm.synced_folder "task/", "/home/vagrant/task"

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
  config.vm.provision "base",           type:"shell",  privileged: false, path: "provision/base.sh"
  config.vm.provision "node_env",       type:"shell",  privileged: false, path: "provision/node_env.sh"
  config.vm.provision "mongodb_env",    type:"shell",  privileged: false, path: "provision/mongodb_env.sh"

  # config.vm.provision "php_env",        type:"shell",  privileged: false, path: "provision/php_env.sh"
  # config.vm.provision "docker_env",     type:"shell",  privileged: false, path: "provision/docker_env.sh"

  ##
  ## remove comment out after php_env
  ## and then exec > vagrant up --provision
  ##
  # config.vm.synced_folder "html/", "/home/vagrant/html" ,owner: "nginx", group: "nginx" ,mount_options: ["dmode=771,fmode=660"]
  # config.vm.provision "shell",  privileged: false, path: "provision/wordpress.sh", args: ["wp1","Wordpress 1st"]
  # config.vm.provision "shell",  privileged: false, path: "provision/wordpress.sh", args: ["wp2","Wordpress 2nd"]

end

# <<pakeage after base provision>>
# > vagrant up --provision-with base
# > vagrant halt
# > vagrant package
# > vagrant box add myCentOS65 package.box
# replase config.vm.box = "CentOS65" to config.vm.box = "myCentOS65"

# <<rollback>>
# sudo yum erase nginx -y; chmod 700 /home/vagrant/;  rm -r /home/vagrant/html/*
# echo "drop database wordpress;" |  mysql -u root -p

# sudo yum erase -y mysql-community* ; sudo rm -r /var/lib/mysql/*
# sudo rm /usr/local/bin/composer
# sudo yum erase -y php*
# sudo yum erase -y nginx

# sudo rm /usr/share/pki/ca-trust-source/anchors/*
