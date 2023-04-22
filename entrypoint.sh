#!/bin/bash
if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi

if [ ! -f ".env" ]; then
    echo "creating .env file"
    cp .env.example .env
fi

php artisan key:generate
php artisan config:clear
php artisan view:clear
php artisan cache:clear
php artisan config:cache

php-fpm -D
nginx -g "daemon off;"
