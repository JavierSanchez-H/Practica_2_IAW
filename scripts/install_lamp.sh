#!/bin/bash

set -ex

#Actualizar Repositorios
apt update

apt upgrade -y

apt install apache2 -y

a2enmod rewrite

cp ../conf/000-default.conf /etc/apache2/sites-available

apt install php libapache2-mod-php php-mysql -y

systemctl restart apache2

cp ../php/index.php /var/www/html/

apt install mysql-server -y

chown -R www-data:www-data /var/www/html/*