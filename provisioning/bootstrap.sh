#!/usr/bin/env bash
function install_message() {
    echo -e "\n\e[94m\e[103m*********** ${1} ***********\n"
}

DBHOST="localhost"
DBNAME="dr_netmidas"
DBUSER="dr_nmuser"
DBPASSWD="8pBefSknDxj6EUvMWMufrq2J"

install_message "Update and Upgrade everything"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

install_message "Setting up PHP ppa"
# Remove previous php PPA and add the new one
sudo apt-get install ppa-purge
sudo ppa-purge -y ppa:ondrej/php5-5.6
sudo apt-get purge php5-fpm && apt-get --purge autoremove
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoclean
sudo apt-get -y autoremove
sudo apt-get -y install php7.0
sudo apt-get -y install php7.0-mysql
sudo apt-get -y install php7.0-mbstring

#drush dependencies
sudo apt-get -y install php7.0-dom
sudo apt-get -y install php7.0-xml
sudo apt-get -y install php7.0-zip
sudo apt-get -y install php7.0-common
sudo apt-get -y install php7.0-curl

install_message "Setting up apache2"
# Install Apache
# apt-get install -y apache2 // Already installed
sudo a2enmod rewrite # Enabling mode rewrite

sudo a2dismod php5 # Disable PHP 5.6
sudo a2enmod php7.0 # Enable PHP 7.0
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf # Modify apache to allow override
sudo a2dissite *.conf

install_message "Create Database, db user and db password"
# Seting up Database
mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS $DBNAME;"
mysql -u root -proot -e "GRANT ALL ON $DBNAME.* TO $DBUSER@$DBHOST IDENTIFIED BY \"$DBPASSWD\";"

install_message "install composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

install_message "install drush"
sudo composer global require drush/drush:dev-master
sudo ln -s $HOME/.composer/vendor/bin/drush /usr/local/bin/drush
drush status

install_message "install drupal from composer"
cd /var/www/html/netmidas
sudo composer create-project drupal-composer/drupal-project:~8.0 public_html --stability dev --no-interaction
cd netmidas/public_html/web
../vendor/bin/drush site-install --db-url=mysql://$DBUSER:$DBPASSWD@$DBHOST/$DBNAME
