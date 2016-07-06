#!/bin/sh

set -x

#load config file
source ~/provision/config_value

#install wp-cli
if [ ! -e ~/bin/wp-cli.phar ]; then
    mkdir -p ~/bin
    cd ~/bin
    curl -sS -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    php ~/bin/wp-cli.phar --info
fi


#create database for wordpress
create_user=$(cat << EOS
insert into user (user,password,host)
    select * from (SELECT "${WORDPRESS_DB_USER}", password("${WORDPRESS_DB_PASS}"), "localhost") as X
    where not EXISTS (select user from user where user="${WORDPRESS_DB_USER}")
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

WP_DIR=$WWWROOT/$1
WP_URL=$WORDPRESS_HOST/$1/
WP_LOCATION=$(cat << EOS
# WordPress on sub folder
location /$1/{
    index  index.php index.html index.htm;
    try_files \$uri \$uri/ /$1/index.php?q=\$uri&\$args;
}
EOS
)

#install wordpress
if [ ! -e $WP_DIR/wp-config.php ]; then
    php ~/bin/wp-cli.phar core download --locale=ja --path=$WP_DIR
    sudo usermod -aG nginx $USER
    sudo chown -R nginx:nginx $WP_DIR
    sudo chmod -R 2770 $WP_DIR/

    cd $WP_DIR

    #certificate
    cp wp-includes/certificates/ca-bundle.crt wp-includes/certificates/ca-bundle.crt.org
    cat wp-includes/certificates/ca-bundle.crt.org /usr/share/pki/ca-trust-source/anchors/* > wp-includes/certificates/ca-bundle.crt

    # nginx config
    sudo echo "$WP_LOCATION" | sudo tee /etc/nginx/conf.d/localhost.$1.sub
    #db
    php ~/bin/wp-cli.phar core config --dbname=$WORDPRESS_DB --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASS --dbhost=localhost --dbprefix=$1_

    # setup
    php ~/bin/wp-cli.phar core install --url="$WP_URL" --title="$WORDPRESS_SITENAME" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASS --admin_email=$WORDPRESS_ADMIN_MAIL
    php ~/bin/wp-cli.phar option update siteurl "$WP_URL"
    php ~/bin/wp-cli.phar option update home "$WP_URL"
    php ~/bin/wp-cli.phar option update blogname "$2"
    php ~/bin/wp-cli.phar option update blogdescription "$WORDPRESS_SITEDESCRIPTION"
    php ~/bin/wp-cli.phar option update permalink_structure "/%postname%"

    # git
    curl -sS https://raw.githubusercontent.com/github/gitignore/master/WordPress.gitignore > .gitignore
    git init
    git add .
    git commit -am "Initial"

fi

# task for wordpress
wp_task_dir=~/task/wp
if [ -e $wp_task_dir ]; then
    cd $wp_task_dir
    #plese see package.json
    npm install

    # cd ~/task/wp; gulp
fi
