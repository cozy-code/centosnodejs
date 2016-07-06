#!/bin/sh

set -x

#load config file
source ~/provision/config_value

#nginx
if !(which nginx >/dev/null); then
    #Install packeage
    sudo rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    sudo yum update -y
    sudo yum -y install nginx

    # over write configuration
    sudo mv -b /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.backup
    sudo sed  -e "s|\${WWWROOT}|$WWWROOT|" ~/provision/etc/nginx/conf.d/default.conf | sudo tee /etc/nginx/conf.d/default.conf

    #add read permission to nginx root folder
    root_with_home=`echo $WWWROOT | grep -o -P '\/home\/.+?\/'`
    if [ ! "$root_with_home" = "" ]; then
        sudo chmod 711 $root_with_home
    fi

    mkdir -p  $WWWROOT
    sudo usermod -aG nginx $USER
    sudo chmod -R 2770 $WWWROOT
    sudo chown -R nginx.nginx $WWWROOT
    #start as service
    sudo /etc/init.d/nginx start
    sudo chkconfig nginx on
fi

#php
if !(yum list installed | grep ^php > /dev/null); then
    #Install packeage
    sudo yum install epel-release
    sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

    sudo yum update -y
    #yum -y install php-mysql php-common php php-cgi php-fpm php-gd php-mbstring
    sudo yum -y install --enablerepo=remi,remi-php56 php-mysql php-common php php-cgi php-fpm php-gd php-mbstring

    # over write configuration
    sudo mv -b /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.back
    sudo cp ~/provision/etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf

    #start as service
    sudo /etc/init.d/php-fpm start
    sudo chkconfig php-fpm on
fi

#composer
if [ ! -e /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
else
    sudo /usr/local/bin/composer self-update
fi

#MySQL
if !(yum list installed | grep ^mysql-community-server > /dev/null); then
    #Install packeage
    sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
    sudo yum update -y
    sudo yum -y install mysql mysql-server

    # over write configuration
    sudo mv -b /etc/my.cnf /etc/my.cnf.backup
    sudo cp ~/provision/etc/my.cnf /etc/my.cnf

    #start as service
    sudo /etc/init.d/mysqld start
    sudo chkconfig mysqld on

    #set password
    /usr/bin/mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
    /usr/bin/mysqladmin -u root --password=$MYSQL_ROOT_PASSWORD -h localhost.localdomain password "$MYSQL_ROOT_PASSWORD"

fi
