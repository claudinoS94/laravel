FROM php:8.1-fpm as php

# FOR DEV SET TO 0 AND PROD SET TO 1
ENV PHP_OPCACHE_ENABLE=0
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=0

RUN usermod -u 1000 www-data

RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev nginx
RUN docker-php-ext-install pdo pdo_mysql bcmath curl opcache

WORKDIR /var/www

COPY --chown=www-data:www-data . .

RUN chown -R www-data:www-data /var/www/storage
RUN chmod -R 755 /var/www/storage
RUN chmod -R 755 /var/www/bootstrap

COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

COPY --from=composer:2.5.5 /usr/bin/composer /usr/bin/composer

ENTRYPOINT [ "docker/entrypoint.sh" ]
