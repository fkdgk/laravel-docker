#!/bin/sh
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
mv composer.phar composer
rm composer-setup.php
chown laravel:laravel composer
