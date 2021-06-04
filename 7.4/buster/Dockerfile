FROM php:7.4.20-fpm-buster

MAINTAINER Lukas Beranek <lukas@beecom.io>

ENV APCU_VERSION 5.1.18
ENV REDIS_VERSION 4.3.0
ENV MCRYPT_VERSION 1.0.3
ENV PHP_MEMORY_LIMIT 2G
ENV PHP_PORT 9000
ENV PHP_PM dynamic
ENV PHP_PM_MAX_CHILDREN 20
ENV PHP_PM_START_SERVERS 10
ENV PHP_PM_MIN_SPARE_SERVERS 4
ENV PHP_PM_MAX_SPARE_SERVERS 10

RUN apt update \
    && apt install -y --no-install-recommends \
      wget \
      libxml2 \
      libxml2-dev \
      patch \
      libzip-dev \
      libsodium-dev \
      zlib1g-dev \
      libxslt-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng-dev \
      unzip \
      procps \
      git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/* && rm -rf /tmp/* /var/tmp/*

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-* /usr/src/php/ext/redis

RUN docker-php-ext-configure gd \
    --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
      gd \
      bcmath \
      opcache \
      pdo_mysql \
      soap \
      zip \
      xsl \
      intl \
      redis \
      sodium \
      exif \
      sockets \
      pcntl && \
      pecl install \
      apcu-${APCU_VERSION} && \
      docker-php-ext-enable --ini-name 20-apcu.ini apcu && \
      pecl install mcrypt-${MCRYPT_VERSION} && \
      docker-php-ext-enable \
      mcrypt

RUN export NEWRELIC_VERSION=$(curl -sS https://download.newrelic.com/php_agent/release/ | sed -n 's/.*>\(.*linux\).tar.gz<.*/\1/p') \
    && curl -L -o newrelic.tar.gz https://download.newrelic.com/php_agent/release/$NEWRELIC_VERSION.tar.gz \
    && gzip -dc newrelic.tar.gz | tar xf - \
    && cd $NEWRELIC_VERSION \
    && NR_INSTALL_SILENT=true NR_INSTALL_USE_CP_NOT_LN=true ./newrelic-install install \
    && rm /usr/local/etc/php/conf.d/newrelic.ini \
    && cd .. \
    && rm -rf $NEWRELIC_VERSION \
    && rm newrelic.tar.gz \
    && mkdir -p /var/log/newrelic/ && touch /var/log/newrelic/newrelic-daemon.log && chmod 666 /var/log/newrelic/newrelic-daemon.log

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY conf/php.ini /usr/local/etc/php/conf.d/10_php.ini
COPY conf/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
