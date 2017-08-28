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
sudo apt-get -y install php7.0-gd

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
composer create-project drupal-composer/drupal-project:8.x-dev public_html --stability dev --no-interaction

install_message "install drush"
wget https://github.com/drush-ops/drush/releases/download/8.1.13/drush.phar
php drush.phar core-status
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush
drush init -y

install_message "install drupal from drush"
cd /var/www/html/netmidas/public_html
drush site-install --db-url=mysql://$DBUSER:$DBPASSWD@127.0.0.1/$DBNAME --yes --account-pass=admin --yes --verbose
drush pmu update -y

install_message "configure files required"
cp sites/default/default.settings.php sites/default/settings.php
cp sites/default/default.services.yml sites/default/services.yml
chmod a+w sites/default/settings.php
chmod a+w sites/default/services.yml
chmod a+w sites/default

install_message "get packages info"
composer config repositories.drupal composer https://packages.drupal.org/8

install_message "admin modules"
composer require drupal/admin_toolbar

install_message "devel modules"
composer require drupal/devel

install_message "REST first"
composer require drupal/libraries
composer require drupal/restui

install_message "Creating the virtual host file"
sudo ln -s -f /var/www/html/netmidas/provisioning/apache.conf /etc/apache2/sites-available/netmidas.conf
sudo a2ensite netmidas.conf
sudo service apache2 reload
