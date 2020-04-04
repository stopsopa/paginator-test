FROM php:7.2.1-fpm

RUN apt-get update && apt-get install -y \
        libicu-dev \
        git \
    && docker-php-ext-install \
        pdo_mysql \
        opcache \
        intl \
    && pecl install apcu \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

COPY php-custom.conf /usr/local/etc/php-fpm.d/zz-php-custom.conf
