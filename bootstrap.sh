#!/usr/bin/env bash
PROJECT="guifi"
PASSWD="1234567890"
DRUPAL="drupal-7.42.tar.gz"
MYSQL_DB="guifi_dev"
MYSQL_USER="guifi"
MYSQL_PASSWD="guifinet"

# update / upgrade
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

sudo apt-get -y install libapache2-mod-php5 php5-gd

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECT}"
    <Directory "/var/www/html/${PROJECT}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
sudo su -c "echo \"${VHOST}\" > /etc/apache2/sites-available/000-default.conf"

# enable mod_rewrite
sudo a2enmod rewrite

# change user
sudo sed -i 's/www-data/vagrant/' /etc/apache2/envvars

# restart apache
sudo service apache2 restart

# install git
sudo apt-get -y install git

# directory zip
sudo mkdir -p /var/www/zip

# install drupal
sudo mkdir -p /var/www/html/
cd /var/www/html/
sudo wget http://ftp.drupal.org/files/projects/$DRUPAL
sudo tar zxf $DRUPAL
sudo mv $DRUPAL ../zip/

# Link symbolic
sudo ln -s /var/www/html/drupal-* /var/www/html/${PROJECT}

# Instal·lar moduls
cd drupal-*/sites/all/modules/
MODULS_LIST="fivestar-7.x-2.1 votingapi-7.x-2.12 front-7.x-2.4 diff-7.x-3.2 eu_cookie_compliance-7.x-1.14 spambot-7.x-1.4 devel-7.x-1.5 image-7.x-1.x-dev image_filter-7.x-1.0"
for module in $MODULS_LIST
do
  sudo wget http://ftp.drupal.org/files/projects/${module}.tar.gz
  sudo tar zxf ${module}.tar.gz
  sudo mv ${module}.tar.gz ../../../../../zip/
done

# BD
cd /var/www/html/
sudo wget http://www.guifi.net/guifi66_devel.sql.gz
echo "create database ${MYSQL_DB};" | mysql -u root -p${PASSWD}
echo "grant all on ${MYSQL_DB}.* to ${MYSQL_USER}@localhost identified by '${MYSQL_PASSWD}';" | mysql -u root -p${PASSWD}

sudo gunzip guifi66_devel.sql.gz
mysql -u root -p${PASSWD} ${MYSQL_DB} < guifi66_devel.sql

cd drupal-*
sudo mkdir {files,files/nanostation,tmp}
sudo chmod 777 {files,files/nanostation,tmp}

# chown vagrant
sudo chown -R vagrant:vagrant /var/www

# settings.php
cd /var/www/html/drupal-*/sites/default/
sudo cp default.settings.php settings.php
sudo sed -i "s|mysql://username:password@localhost/databasename|mysql://${MYSQL_USER}:${MYSQL_PASSWD}@localhost/${MYSQL_DB}|" settings.php
