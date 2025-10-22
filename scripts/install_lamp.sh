#!/bin/bash
set -ex

# importamos variables
source .env

# actualizamos paquetes
sudo dnf update -y

# instalamos apache
sudo dnf install -y httpd
sudo systemctl enable httpd

# instalamos php y módulos necesarios
sudo dnf install -y php php-mysqlnd php-mbstring php-zip php-gd php-json php-xml
sudo systemctl restart httpd

# instalamos mariadb
sudo dnf install -y mariadb-server
sudo systemctl enable mariadb


# copiamos configuración de apache
sudo cp ../conf/000-default.conf /etc/httpd/conf.d/default.conf

# creamos la página php de información
sudo cp ../php/index.php /var/www/html/index.php

# aplicamos permisos al directorio web
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# creamos base de datos y usuario
sudo mysql -u root -e "create database if not exists $DB_NAME;"
sudo mysql -u root -e "create user if not exists '$DB_USER'@'localhost' identified by '$DB_PASSWORD';"
sudo mysql -u root -e "grant all privileges on $DB_NAME.* to '$DB_USER'@'localhost';"
sudo mysql -u root -e "flush privileges;"

# reiniciamos servicios
sudo systemctl restart httpd
sudo systemctl restart mariadb