#!/bin/sh

source /vagrant/config_value

wwwroot=~/nginx/html
#install wp-cli
if [ ! -e ~/bin/wp-cli.phar ]; then
    mkdir -p ~/bin
    cd ~/bin
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    php ~/bin/wp-cli.phar --info
fi


#create database for wordpress
create_user=$(cat << EOS
insert into user set user="${WORDPRESS_DB_USER}", password=password("${WORDPRESS_DB_PASS}"), host="localhost";
EOS
)
create_db=$(cat << EOS
create database ${WORDPRESS_DB};
grant all on ${WORDPRESS_DB}.* to ${WORDPRESS_DB_USER};
FLUSH PRIVILEGES;
EOS
)
#echo $create_db
if !(mysql -u root --password="$MYSQL_ROOT_PASSWORD" -e "show databases" | grep -q "^${WORDPRESS_DB}$"); then
    echo "createing ${WORDPRESS_DB}"
#    echo $create_db
     mysql -u root --password="$MYSQL_ROOT_PASSWORD" -D mysql <<< $create_user
     mysql -u root --password="$MYSQL_ROOT_PASSWORD" -D mysql <<< $create_db
fi

#install wordpress
if [ ! -e $wwwroot/wordpress/wp-config.php ]; then
    php ~/bin/wp-cli.phar core download --locale=ja --path=$wwwroot/wordpress
    sudo usermod -aG nginx vagrant
    sudo chown -R nginx.nginx $wwwroot/wordpress

    cd $wwwroot/wordpress
    #db
    php ~/bin/wp-cli.phar core config --dbname=$WORDPRESS_DB --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASS --dbhost=localhost --dbprefix=wordpress_

    # setup
    php ~/bin/wp-cli.phar core install --url="$WORDPRESS_URL" --title="$WORDPRESS_SITENAME" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASS --admin_email=$WORDPRESS_ADMIN_MAIL
    php ~/bin/wp-cli.phar option update siteurl "$WORDPRESS_URL"
    php ~/bin/wp-cli.phar option update blogname "$WORDPRESS_SITENAME"
    php ~/bin/wp-cli.phar option update blogdescription "$WORDPRESS_SITEDESCRIPTION"
    php ~/bin/wp-cli.phar option update permalink_structure "/%postname%"

fi

