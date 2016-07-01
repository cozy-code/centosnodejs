#!/bin/sh

source /vagrant/config_value

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

    #sudo usermod -aG vagrant nginx
    chmod 755 ~
    chmod 755 wordpress
    cd wordpress

    chmod 0707 wp-content/
    chmod 0707 wp-content/themes/
    chmod 0707 wp-content/plugins/

fi

#create database for wordpress
create_db=$(cat << EOS
insert into user set user="${WORDPRESS_DB_USER}", password=password("${WORDPRESS_DB_PASS}"), host="localhost";
create database ${WORDPRESS_DB};
grant all on ${WORDPRESS_DB}.* to ${WORDPRESS_DB_USER};
FLUSH PRIVILEGES;
EOS
)
echo $create_db
# if !(mysql -u root --password="$MYSQL_ROOT_PASSWORD" -e "show databases" | grep -q "^${WORDPRESS_DB}$"); then
#     echo "createing ${WORDPRESS_DB}"
#     echo $create_db
#     # mysql -u root --password="$MYSQL_ROOT_PASSWORD" -D mysql <<< $create_db
# fi
