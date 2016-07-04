#!/bin/sh

source /vagrant/config_value

#install wp-cli
if [ ! -e ~/bin/wp-cli.phar ]; then
    mkdir -p ~/bin
    cd ~/bin
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
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

WP_DIR=$WWWROOT/wordpress
#install wordpress
if [ ! -e $WP_DIR/wp-config.php ]; then
    php ~/bin/wp-cli.phar core download --locale=ja --path=$WP_DIR
    sudo usermod -aG nginx vagrant
    sudo chown -R nginx.nginx $WP_DIR
    sudo chmod -R 2770 $WP_DIR/

    cd $WP_DIR

    #certificate
    cp wp-includes/certificates/ca-bundle.crt wp-includes/certificates/ca-bundle.crt.org
    cat wp-includes/certificates/ca-bundle.crt.org /usr/share/pki/ca-trust-source/anchors/* > wp-includes/certificates/ca-bundle.crt

    #db
    php ~/bin/wp-cli.phar core config --dbname=$WORDPRESS_DB --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASS --dbhost=localhost --dbprefix=wordpress_

    # setup
    php ~/bin/wp-cli.phar core install --url="$WORDPRESS_URL" --title="$WORDPRESS_SITENAME" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASS --admin_email=$WORDPRESS_ADMIN_MAIL
    php ~/bin/wp-cli.phar option update siteurl "$WORDPRESS_URL"
    php ~/bin/wp-cli.phar option update blogname "$WORDPRESS_SITENAME"
    php ~/bin/wp-cli.phar option update blogdescription "$WORDPRESS_SITEDESCRIPTION"
    php ~/bin/wp-cli.phar option update permalink_structure "/%postname%"

    # git
    curl https://raw.githubusercontent.com/github/gitignore/master/WordPress.gitignore > .gitignore
    git init
    git add .
    git commit -am "Initial"

fi

# task for wordpress
wp_task_dir=~/src/wp
if [ ! -e $wp_task_dir ]; then
    mkdir -p $wp_task_dir
    cd $wp_task_dir
    npm init -y
    npm install --save-dev gulp
    npm install --save-dev gulp-sass
    npm install --save-dev gulp-autoprefixer
    npm install --save-dev gulp-cssmin
    npm install --save-dev gulp-rename
    npm install --save-dev browser-sync

    cp /vagrant/etc/wp/gulpfile.js .
fi
