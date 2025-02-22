#!/bin/bash

# Обновление операционной системы
sudo apt update && sudo apt upgrade -y

# Установка необходимых пакетов
sudo apt install -y ca-certificates apt-transport-https software-properties-common

# Добавление PPA для PHP
sudo add-apt-repository -y ppa:ondrej/php

# Обновление репозитория
sudo apt update

# Установка Apache, MySQL, PHP и необходимых расширений
sudo apt install -y apache2 mysql-server php8.2 php-mysql php-mbstring php-xml php-curl php-zip php-gd php-intl php-soap

# Перезапуск службы Apache
sudo systemctl restart apache2.service

# Скачивание и разархивирование Moodle
wget https://download.moodle.org/download.php/direct/stable403/moodle-latest-403.tgz
sudo mv moodle-latest-403.tgz /var/www/html/
cd /var/www/html/
sudo tar -xf moodle-latest-403.tgz 
cd ..

# Создание папки moodledata и установка прав доступа
sudo mkdir moodledata
sudo chown www-data moodledata

# Создание базы данных MySQL и пользователя для Moodle
sudo mysql -e "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'Test123';"
sudo mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'moodleuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -e "quit"

# Настройка прав доступа для Moodle
sudo chmod -R 777 /var/www/html/moodle

# Изменение настроек php.ini
sudo sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.2/apache2/php.ini

# Перезапуск службы Apache
sudo systemctl restart apache2.service

echo "Установка и настройка Moodle завершена."
