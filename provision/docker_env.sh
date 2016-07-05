#!/bin/sh

#load config file
source ~/provision/config_value

#install docker
if ! ( yum list installed | grep ^docker > /dev/null ); then
    sudo rpm -ivh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/i386/epel-release-6-8.noarch.rpm
    sudo yum -y install docker-io

    #start as service
    sudo /etc/init.d/docker start
    sudo chkconfig docker on

    # enable docker for normal user
    sudo chown root:dockerroot /var/run/docker.sock
    sudo usermod -aG dockerroot $USER
fi


# docker pull tutum/wordpress
# docker run -d -p 81:80 --name=wordpress tutum/wordpress
# access http://192.168.33.10:81/
