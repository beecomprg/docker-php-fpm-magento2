#http://devdocs.magento.com/guides/v2.1/install-gde/system-requirements-tech.html
FROM php:7.2.17-fpm-alpine3.9

MAINTAINER Lukas Beranek <lukas@beecom.io>

ENV APCU_VERSION 5.1.17
ENV REDIS_VERSION 4.2.0
ENV MCRYPT 1.0.2

#BUILD dependencies
RUN apk add --no-cache --no-cache --virtual .deps \
    $PHPIZE_DEPS \
    freetype libpng libjpeg-turbo freetype-dev \
    libpng-dev libjpeg-turbo-dev icu-dev libxml2 libxml2-dev libmcrypt-dev \
    libxslt-dev \
    patch \
    git

RUN  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(getconf _NPROCESSORS_ONLN) && \
  docker-php-ext-install -j${NPROC} gd

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-* /usr/src/php/ext/redis

RUN docker-php-ext-install \
  bcmath \
  opcache \
  pdo_mysql \
  soap \
  zip \
  xsl \
  intl \
  redis \
  pcntl

RUN pecl install \
    apcu-${APCU_VERSION} \
    mcrypt-${MCRYPT} && \
    docker-php-ext-enable apcu && \
    docker-php-ext-enable mcrypt

#cleanup
RUN apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html
