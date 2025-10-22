#!/bin/bash
set -ex
# importamos variables
source .env
# instalamos herramientas necesarias
sudo dnf install -y wget unzip
# instalamos phpmyadmin
cd /var/www/html
sudo rm -rf phpmyadmin phpMyAdmin-*
sudo wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
sudo tar xvf phpMyAdmin-latest-all-languages.tar.gz
sudo rm phpMyAdmin-latest-all-languages.tar.gz
sudo mv phpMyAdmin-* phpmyadmin
sudo chown -R apache:apache /var/www/html/phpmyadmin
sudo chcon -R -t httpd_sys_rw_content_t /var/www/html/phpmyadmin
# creamos base de datos y usuario 
sudo mysql -u root -e "create database if not exists $DB_NAME;"
sudo mysql -u root -e "create user if not exists '$DB_USER'@'localhost' identified by '$DB_PASSWORD';"
sudo mysql -u root -e "grant all privileges on $DB_NAME.* to '$DB_USER'@'localhost';"
sudo mysql -u root -e "flush privileges;"
# reiniciamos servicios
sudo systemctl restart httpd
sudo systemctl restart mysqld