#!/bin/sh

source ./config_value

wwwroot=~/nginx/html
#install wordpress
if [ ! -e $wwwroot/wordpress ]; then
    #download latest version
    mkdir -p ~/download
    cd ~/download
    curl -O https://wordpress.org/latest.zip

    #deploy
    mkdir -p $wwwroot
    cd $wwwroot
    unzip ~/download/latest.zip

    sudo usermod -aG vagrant nginx
    chmod 775 wordpress
fi

#create database for wordpress
create_db=$(cat << EOS
insert into user set user="${WORDPRESS_DB_USER}_user", password=password("${WORDPRESS_DB_PASS}"), host="localhost";
create database ${WORDPRESS_DB};
grant all on ${WORDPRESS_DB}.* to ${WORDPRESS_DB_USER};
FLUSH PRIVILEGES;
EOS
)
if !(mysql -u root --password="$MYSQL_ROOT_PASSWORD" -e "show databases" | grep -q "^${WORDPRESS_DB}$"); then
    echo "createing ${WORDPRESS_DB}"
    mysql -u root --password="$MYSQL_ROOT_PASSWORD" -D mysql <<< $create_db
fi
