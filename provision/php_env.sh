#!/bin/sh

#load config file
source /vagrant/config_value

#nginx
if !(which nginx >/dev/null); then
    #Install packeage
    rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    yum update -y
    yum -y install nginx

    # over write configuration
    mv -b /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.backup
    #cp /vagrant/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
    sed  -e "s|\${WWWROOT}|$WWWROOT|" /vagrant/etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf

    #add read permission to root folder /home/vagrant/nginx/html
    #chmod 711 /home/vagrant
    root_with_home=`echo $WWWROOT | grep -o -P '\/home\/.+?\/'`
    if [ ! "$root_with_home" = "" ]; then
        chmod 711 $root_with_home
    fi

    mkdir -p  $WWWROOT
    usermod -aG nginx vagrant
    chown -R nginx.nginx $WWWROOT
    chmod -R 2770 $WWWROOT
    #start as service
    /etc/init.d/nginx start
    chkconfig nginx on
fi

#php
if !(yum list installed | grep ^php > /dev/null); then
    #Install packeage
    yum install epel-release
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

    yum update -y
    #yum -y install php-mysql php-common php php-cgi php-fpm php-gd php-mbstring
    yum -y install --enablerepo=remi,remi-php56 php-mysql php-common php php-cgi php-fpm php-gd php-mbstring

    # over write configuration
    mv -b /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.back
    cp /vagrant/etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf

    #start as service
    /etc/init.d/php-fpm start
    chkconfig php-fpm on
fi

#composer
if [ ! -e /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
else
    /usr/local/bin/composer self-update
fi

#MySQL
if !(yum list installed | grep ^mysql-community-server > /dev/null); then
    #Install packeage
    yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
    yum update -y
    yum -y install mysql mysql-server

    # over write configuration
    mv -b /etc/my.cnf /etc/my.cnf.backup
    cp /vagrant/etc/my.cnf /etc/my.cnf

    #start as service
    /etc/init.d/mysqld start
    chkconfig mysqld on

    #set password
    /usr/bin/mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
    /usr/bin/mysqladmin -u root --password=$MYSQL_ROOT_PASSWORD -h localhost.localdomain password "$MYSQL_ROOT_PASSWORD"

fi
