FROM php:7.2.1-cli

# https://github.com/docteurklein
RUN apt-get update && apt-get install -y \
        libicu-dev \
        zlib1g-dev \
        libzip-dev \
        git \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
        pdo_mysql \
        opcache \
        intl \
    && pecl install \
        apcu \
        xdebug \
        zip \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini \
    && echo 'zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so' > /usr/local/etc/php/conf.d/xdebug.ini

COPY ./php.ini /usr/local/etc/php/php.ini