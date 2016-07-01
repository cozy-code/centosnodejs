#!/bin/sh

#nginx
if !(which nginx >/dev/null); then
    #Install packeage
    rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    yum update -y
    yum -y install nginx

    # over write configuration
    mv -b /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.backup
    cp /vagrant/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

    #start as service
    /etc/init.d/nginx start
    chkconfig nginx on
fi

#php
if !(yum list installed | grep ^php > /dev/null); then
    #Install packeage
    yum update -y
    yum -y install php-mysql php-common php php-cgi php-fpm php-gd php-mbstring

    # over write configuration
    mv -b /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.back
    cp /vagrant/etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf

    #start as service
    /etc/init.d/php-fpm start
    chkconfig php-fpm on
fi

#MySQL
if !(yum list installed | grep ^mysql-server > /dev/null); then
    #Install packeage
    yum update -y
    yum -y install mysql mysql-server

    # over write configuration
    mv -b /etc/my.cnf /etc/my.cnf.backup
    cp /vagrant/etc/my.cnf /etc/my.cnf

    #start as service
    /etc/init.d/mysqld start
    chkconfig mysqld on

    #set password
    NEW_MYSQL_PASSWORD=vagrant
    /usr/bin/mysqladmin -u root password "$NEW_MYSQL_PASSWORD"
    /usr/bin/mysqladmin -u root --password=$NEW_MYSQL_PASSWORD-h localhost.localdomain password "$NEW_MYSQL_PASSWORD"

fi
